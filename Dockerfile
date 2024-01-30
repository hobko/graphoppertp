# Stage 1: Build Stage
FROM openjdk:17-jdk-slim AS build

# Set the working directory
WORKDIR /app

# Copy local GraphHopper JAR, configuration file, and OSM data
COPY graphhopper-web-8.0.jar .
COPY config-example.yml .
ADD http://download.geofabrik.de/europe/slovakia-latest.osm.pbf .

# Stage 2: Runtime Stage
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy files from the build stage
COPY --from=build /app .

# Expose both ports
EXPOSE 8989 8990

# Run the application
CMD ["java", "-Ddw.graphhopper.datareader.file=slovakia-latest.osm.pbf", "-jar", "graphhopper-web-8.0.jar", "server", "config-example.yml"]
