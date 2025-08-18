version: '3.8'

services:
  mongodb:
    image: mongo:7.0
    restart: unless-stopped
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
      MONGO_INITDB_DATABASE: $${parameters.name}
    volumes:
      - mongodb_data:/data/db
      - ./init-mongo.js:/docker-entrypoint-initdb.d/init-mongo.js:ro
    networks:
      - app-network

volumes:
  mongodb_data:

networks:
  app-network:
    driver: bridge