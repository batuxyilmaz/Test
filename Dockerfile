FROM openjdk:17-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ./target/App-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

FROM jenkins/jenkins:jdk17
USER root
RUN apt-get update && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 sofware-properties-common
RUN curl -fsSLo https://github.com/krallin/tini.releases/download/v0.19.0/tini-static-amd64 -o /sbin/tini
RUN chmod +x /sbin/tini
Run curl -fsSL download.docker.com/linux/debian/gpg | apt-key add -
RUN  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian \ $(lsb_release -cs) stable"
  
RUN apt-get update -qq && apt-get install -qqy docker-ce- docker-ce-cli containerd.io
RUN usermod -aG docker jenkins
ENTRYPOINT ["/sbin/tini", "--", "/bin/sh","-c","service docker start && /usr/local/bin/jenkins.sh"] jenkins-plugin-cli --plugins "blueocean docker-workflow"
