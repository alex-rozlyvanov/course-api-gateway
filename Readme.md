# Course-api-gateway

## This is course-discovery-server microservice of Course application.
### Main technologies:
- Gradle 7.2
- Java 17
- Spring Boot 2.5.5
- Spring Cloud 2020.0.3
- Netflix Eureka Server


### Responsibilities:
- Gateway for the outer world to Course application microservices

## How to build:
**Regular build:** 
- `./gradlew clean build`
- `docker build --network=course_local -t api-gateway .` 
- `docker run -d -p 8079:8079 --network=course_local -h api-gateway --name api-gateway api-gateway`

**Without tests build:** `./gradlew clean build -x test`

**Run complete application in local docker environment:**
- Use `start_application.sh` / `stop_application.sh` from discovery microservice
