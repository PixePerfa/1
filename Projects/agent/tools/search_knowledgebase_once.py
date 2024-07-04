from __future__ import annotations
import re
import warnings
from typing import Dict

from langchain.callbacks.manager import (
    AsyncCallbackManagerForChainRun,
    CallbackManagerForChainRun,
)
from langchain.chains.llm import LLMChain
from langchain.pydantic_v1 import Extra, root_validator
from langchain.schema import BasePromptTemplate
from langchain.schema.language_model import BaseLanguageModel
from typing import List, Any, Optional
from langchain.prompts import PromptTemplate
import sys
import os
import json

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from server.chat.knowledge_base_chat import knowledge_base_chat
from configs import VECTOR_SEARCH_TOP_K, SCORE_THRESHOLD, MAX_TOKENS

import asyncio
from server.agent import model_container
from pydantic import BaseModel, Field

async def search_knowledge_base_iter(database: str, query: str):
    response = await knowledge_base_chat(query=query,
                                         knowledge_base_name=database,
                                         model_name=model_container. MODEL.model_name,
                                         temperature=0.01,
                                         history=[],
                                         top_k=VECTOR_SEARCH_TOP_K,
                                         max_tokens=MAX_TOKENS,
                                         prompt_name="knowledge_base_chat",
                                         score_threshold=SCORE_THRESHOLD,
                                         stream=False)

    contents = ""
    async for data in response.body_iterator: # The data here is a JSON string
        data = json.loads(data)
        contents += data["answer"]
        docs = data["docs"]
    return contents


_PROMPT_TEMPLATE = """
The user will ask a question that requires you to consult the knowledge base, and you should think about it according to the ideas I provided
Question: ${{User's Problem}}
These databases are accessible to you, with their names before the colon and their features after the colon:

{database_names}

Your answer should be formatted as follows, please note that tags such as '''' text in the format must be output, which is the tag I used to extract the answer.
```text
${{Name of the knowledge base}}
```
```output
The result of a database query
```
Answer: ${{Answer}}

Now, here's my question:
Question: {question}

"""
PROMPT = PromptTemplate(
    input_variables=["question", "database_names"],
    template=_PROMPT_TEMPLATE,
)


class LLMKnowledgeChain(LLMChain):
    llm_chain: LLMChain
    llm: Optional[BaseLanguageModel] = None
    """[Deprecated] LLM wrapper to use."""
    prompt: BasePromptTemplate = PROMPT
    """[Deprecated] Prompt to use to translate to python if necessary."""
    database_names: Dict[str, str] = model_container. DATABASE
    input_key: str = "question"  #: :meta private:
    output_key: str = "answer"  #: :meta private:

    class Config:
        """Configuration for this pydantic object."""

        extra = Extra.forbid
        arbitrary_types_allowed = True

    @root_validator(pre=True)
    def raise_deprecation(cls, values: Dict) -> Dict:
        if "llm" in values:
            warnings.warn(
                "Directly instantiating an LLMKnowledgeChain with an llm is deprecated. "
                "Please instantiate with llm_chain argument or using the from_llm "
                "class method."
            )
            if "llm_chain" not in values and values["llm"] is not None:
                prompt = values.get("prompt", PROMPT)
                values["llm_chain"] = LLMChain(llm=values["llm"], prompt=prompt)
        return values

    @property
    def input_keys(self) -> List[str]:
        """Expect input key.

        :meta private:
        """
        return [self.input_key]

    @property
    def output_keys(self) -> List[str]:
        """Expect output key.

        :meta private:
        """
        return [self.output_key]

    def _evaluate_expression(self, dataset, query) -> str:
        try:
            output = asyncio.run(search_knowledge_base_iter(dataset, query))
        except Exception as e:
            output = "The information entered is incorrect or the knowledge base does not exist"
            return output
        return output

    def _process_llm_result(
            self,
            llm_output: str,
            llm_input: str,
            run_manager: CallbackManagerForChainRun
    ) -> Dict[str, str]:

        run_manager.on_text(llm_output, color="green", verbose=self.verbose)

        llm_output = llm_output.strip()
        text_match = re.search(r"^```text(.*?) ```", llm_output, re. DOTALL)
        if text_match:
            database = text_match.group(1).strip()
            output = self._evaluate_expression(database, llm_input)
            run_manager.on_text("\nAnswer: ", verbose=self.verbose)
            run_manager.on_text(output, color="yellow", verbose=self.verbose)
            answer = "Answer: " + output
        elif llm_output.startswith("Answer:"):
            answer = llm_output
        elif "Answer:" in llm_output:
            answer = "Answer: " + llm_output.split("Answer:")[-1]
        else:
            return {self.output_key: f" is not in the right format: {llm_output}"}
        return {self.output_key: answer}

    async def _aprocess_llm_result(
            self,
            llm_output: str,
            run_manager: AsyncCallbackManagerForChainRun,
    ) -> Dict[str, str]:
        await run_manager.on_text(llm_output, color="green", verbose=self.verbose)
        llm_output = llm_output.strip()
        text_match = re.search(r"^```text(.*?) ```", llm_output, re. DOTALL)
        if text_match:
            expression = text_match.group(1)
            output = self._evaluate_expression(expression)
            await run_manager.on_text("\nAnswer: ", verbose=self.verbose)
            await run_manager.on_text(output, color="yellow", verbose=self.verbose)
            answer = "Answer: " + output
        elif llm_output.startswith("Answer:"):
            answer = llm_output
        elif "Answer:" in llm_output:
            answer = "Answer: " + llm_output.split("Answer:")[-1]
        else:
            raise ValueError(f"unknown format from LLM: {llm_output}")
        return {self.output_key: answer}

    def _call(
            self,
            inputs: Dict[str, str],
            run_manager: Optional[CallbackManagerForChainRun] = None,
    ) -> Dict[str, str]:
        _run_manager = run_manager or CallbackManagerForChainRun.get_noop_manager()
        _run_manager.on_text(inputs[self.input_key])
        data_formatted_str = ',\n'.join([f' "{k}":"{v}"' for k, v in self.database_names.items()])
        llm_output = self.llm_chain.predict(
            database_names=data_formatted_str,
            question=inputs[self.input_key],
            stop=["```output"],
            callbacks=_run_manager.get_child(),
        )
        return self._process_llm_result(llm_output, inputs[self.input_key], _run_manager)

    async def _acall(
            self,
            inputs: Dict[str, str],
            run_manager: Optional[AsyncCallbackManagerForChainRun] = None,
    ) -> Dict[str, str]:
        _run_manager = run_manager or AsyncCallbackManagerForChainRun.get_noop_manager()
        await _run_manager.on_text(inputs[self.input_key])
        data_formatted_str = ',\n'.join([f' "{k}":"{v}"' for k, v in self.database_names.items()])
        llm_output = await self.llm_chain.apredict(
            database_names=data_formatted_str,
            question=inputs[self.input_key],
            stop=["```output"],
            callbacks=_run_manager.get_child(),
        )
        return await self._aprocess_llm_result(llm_output, inputs[self.input_key], _run_manager)

    @property
    def _chain_type(self) -> str:
        return "llm_knowledge_chain"

    @classmethod
    def from_llm(
            cls,
            llm: BaseLanguageModel,
            prompt: BasePromptTemplate = PROMPT,
            **kwargs: Any,
    ) -> LLMKnowledgeChain:
        llm_chain = LLMChain(llm=llm, prompt=prompt)
        return cls(llm_chain=llm_chain, **kwargs)


def search_knowledgebase_once(query: str):
    model = model_container. MODEL
    llm_knowledge = LLMKnowledgeChain.from_llm(model, verbose=True, prompt=PROMPT)
    ans = llm_knowledge.run(query)
    return ans


class KnowledgeSearchInput(BaseModel):
    location: str = Field(description="The query to be searched")


if __name__ == "__main__":
    result = search_knowledgebase_once ("Male to female ratio of big data")
    print(result)
