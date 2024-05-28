pip install streamlit

import streamlit as st
import numpy as np
import lancedb

# Connect to LanceDB
db = lancedb.connect()
collection = db.collection("code_embeddings")

# Fetch all embeddings
embeddings = collection.all()
embeddings_data = [{"id": doc["id"], "embedding": np.array(doc["embedding"])} for doc in embeddings]

st.title("Embeddings Visualization")
st.write("Number of embeddings:", len(embeddings_data))

# Display embeddings
for data in embeddings_data:
    st.write(f"ID: {data['id']}, Embedding: {data['embedding']}")

***********
import streamlit as st
import requests

st.title("Unified LLM Interface")
selected_task = st.sidebar.selectbox("Select Task", ["AutoGen", "CrewAI", "ChatDev", "Camel Project", "Flowise"])

if selected_task == "Flowise":
    st.write("Creating a Flowise flow...")
    # Add input fields for flow parameters
    flow_name = st.text_input("Flow Name")
    flow_steps = st.text_area("Flow Steps (one per line)")

    if st.button("Generate Flow"):
        # Send request to backend to generate Flowise flow
        response = requests.post("http://localhost:5000/generate_flow", json={"flow_name": flow_name, "flow_steps": flow_steps})
        st.write(response.json())
