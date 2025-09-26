# Stage 1: Build the app
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy all code (parent pom + modules)
COPY . .

# Build the project (skip tests to speed up)
RUN mvn -f Amazon/pom.xml clean package -DskipTests

# Stage 2: Prepare runtime container
FROM tomcat:9.0-jdk17
WORKDIR /usr/local/tomcat/webapps/

# Copy WAR file from the module that produces it (adjust module name)
COPY --from=build /app/Amazon/Amazon-Web/target/*.war /usr/local/tomcat/webapps/Amazon.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
