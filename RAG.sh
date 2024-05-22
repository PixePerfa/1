#  Sukuria 4 - RAG  === / qdrant / chroma / redis / faiss /
# 

# Install dependencies for building Faiss
sudo apt-get update
sudo apt-get install -y cmake libopenblas-dev liblapack-dev liblapacke-dev libatlas-base-dev libprotobuf-dev protobuf-compiler

# Install dependencies for Qdrant
sudo apt-get install -y build-essential libssl-dev pkg-config libgflags-dev libsnappy-dev zlib1g-dev

# Install dependencies for Chroma
sudo apt-get install -y build-essential libatlas-base-dev libboost-all-dev libprotobuf-dev protobuf-compiler libyaml-cpp-dev

# Install Redis dependencies
sudo apt-get install -y build-essential tcl

# Clone Faiss repository
git clone https://github.com/facebookresearch/faiss.git
cd faiss
git checkout v1.7.1  # Use the version you prefer

# Build and install Faiss
cmake -B build .
cmake --build build --target python
pip install -e .

# Clone Qdrant repository
cd ..
git clone https://github.com/qdrant/qdrant.git
cd qdrant

# Install Qdrant
pip install -r requirements.txt
pip install -e .

# Clone Chroma repository
cd ..
git clone https://github.com/chromesearcher/chroma.git
cd chroma

# Install Chroma
pip install -e .

# Download and install Redis
cd ..
wget http://download.redis.io/releases/redis-6.2.5.tar.gz
tar xzf redis-6.2.5.tar.gz
cd redis-6.2.5
make

# Start Redis server
src/redis-server
