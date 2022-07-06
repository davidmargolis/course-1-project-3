FROM openjdk:11-jre-slim-buster
COPY target/hello-1.0.0.jar .
RUN pip install flask
CMD ["java","-jar","hello-1.0.0.jar"]
