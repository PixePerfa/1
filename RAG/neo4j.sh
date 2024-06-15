  dev-neo4j:
    container_name: devneo4j
    hostname: neo4j
    image: neo4j:5.15.0-community
    ports:
      - 7474:7474
      - 7687:7687
    restart: always
    volumes:
      - $HOME/neo4j/data:/data:Z
      - $HOME/neo4j/logs:/logs:Z
    environment:
      - NEO4J_AUTH=none
    networks:
      - mynetwork
