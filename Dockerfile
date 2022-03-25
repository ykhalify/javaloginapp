FROM tomcat:latest

MAINTAINER Sara

COPY ./bootcamp.war /usr/local/tomcat/webapps

FROM BASE_IMAGE

ARG CONTRAST_AGENT_VERSION

ADD https://repo1.maven.org/maven2/com/contrastsecurity/contrast-agent/$CONTRAST_AGENT_VERSION/contrast-agent-$CONTRAST_AGENT_VERSION.jar 
/opt/contrast/contrast.jar
