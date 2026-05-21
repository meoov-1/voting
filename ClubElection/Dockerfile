FROM tomcat:10-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/ClubElection.war /usr/local/tomcat/webapps/ROOT.war

CMD sed -i 's/port="8080"/port="'"$PORT"'"/' /usr/local/tomcat/conf/server.xml && catalina.sh run