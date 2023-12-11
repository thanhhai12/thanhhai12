# Use the latest Maven image as the build environment
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn clean install

# Use the official OpenJDK image as the runtime environment
FROM openjdk:latest
WORKDIR /app

# Copy the JAR file from the build environment to the container
COPY --from=build /app/target/*.jar app.jar

# Expose the port that your Spring Boot app will run on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
