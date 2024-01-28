# Stage 1: Build Stage
FROM openjdk:17-jdk-slim AS build

# Set the working directory
WORKDIR /app

# Download GraphHopper JAR, configuration file, and OSM data
RUN apt-get update && apt-get install -y curl \
    && curl -O https://repo1.maven.org/maven2/com/graphhopper/graphhopper-web/8.0/graphhopper-web-8.0.jar \
    && curl -O https://raw.githubusercontent.com/graphhopper/graphhopper/8.x/config-example.yml \
    && curl -O http://download.geofabrik.de/europe/slovakia-latest.osm.pbf

# Stage 2: Runtime Stage
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy files from the build stage
COPY --from=build /app/graphhopper-web-8.0.jar ./graphhopper-web-8.0.jar
COPY --from=build /app/config-example.yml ./config-example.yml
COPY --from=build /app/slovakia-latest.osm.pbf ./slovakia-latest.osm.pbf

# Run the application
CMD ["java", "-Ddw.graphhopper.datareader.file=slovakia-latest.osm.pbf", "-jar", "graphhopper-web-8.0.jar", "server", "config-example.yml"]
