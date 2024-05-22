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
