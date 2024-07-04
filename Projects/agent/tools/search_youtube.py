# Langchain's built-in YouTube search tool encapsulation
from langchain.tools import YouTubeSearchTool
from pydantic import BaseModel, Field
def search_youtube(query: str):
    tool = YouTubeSearchTool()
    return tool.run(tool_input=query)

class YoutubeInput(BaseModel):
    location: str = Field(description="Query for Videos search")
