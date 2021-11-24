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


**Push docker image to ECR:**
- aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/k7s0v3p5
- docker build -t course-api-gateway:0.0.1 .
- docker tag course-api-gateway:0.0.1 public.ecr.aws/k7s0v3p5/course-api-gateway:0.0.1
- docker push public.ecr.aws/k7s0v3p5/course-api-gateway:0.0.1
