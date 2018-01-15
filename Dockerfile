FROM websphere-liberty:microProfile
MAINTAINER IBM Java engineering at IBM Cloud
COPY server.xml /config/server.xml
# Install required features if not present
RUN installUtility install --acceptLicense defaultServer && installUtility install --acceptLicense apmDataCollector-7.4
RUN /opt/ibm/wlp/usr/extension/liberty_dc/bin/config_liberty_dc.sh -slient /opt/ibm/wlp/usr/extension/liberty_dc/bin/slient_config_liberty_dc.txt
COPY target/microservice-speaker-1.0.0-SNAPSHOT.war /config/apps/speaker.war
# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \ 
  if [ $LICENSE_JAR_URL ]; then \
    wget $LICENSE_JAR_URL -O /tmp/license.jar \
    && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
    && rm /tmp/license.jar; \
  fi
