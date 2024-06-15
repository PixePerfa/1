version: '3.7'

services:
  mongo:
    image: mongo
    container_name: mongo_container
    restart: always
    ports:
      - "10000:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: luke
      MONGO_INITDB_ROOT_PASSWORD: lukeluke
    networks:
      - my_network

  mongo-express:
    image: mongo-express
    restart: always
    ports:
      - 8081:8081
    environment:
      ME_CONFIG_MONGODB_ADMINUSERNAME: luke
      ME_CONFIG_MONGODB_ADMINPASSWORD: lukeluke
      ME_CONFIG_MONGODB_URL: mongodb://luke:luke@mongo:27017/
      ME_CONFIG_BASICAUTH: false
    networks:
      - my_network

  networks:
    my_network
