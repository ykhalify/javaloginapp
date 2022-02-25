FROM tomcat:latest

MAINTAINER Hiba

COPY ./webapp.war /usr/local/tomcat/webapps
