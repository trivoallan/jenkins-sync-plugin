FROM quay.io/openshift/origin-jenkins-agent-maven:v4.0 AS builder
USER 0
WORKDIR /java/src/github.com/openshift/jenkins-sync-plugin
COPY pom.xml .
RUN export PATH=/opt/rh/rh-maven35/root/usr/bin:$PATH && mvn dependency:go-offline
COPY . .
RUN export PATH=/opt/rh/rh-maven35/root/usr/bin:$PATH && mvn package

FROM openshift/jenkins-2-centos7:v3.11
COPY --from=builder /java/src/github.com/openshift/jenkins-sync-plugin/target/openshift-sync.hpi /opt/openshift/plugins
RUN mv /opt/openshift/plugins/openshift-sync.hpi /opt/openshift/plugins/openshift-sync.jpi
ADD http://mirrors.jenkins.io/war/2.198/jenkins.war /usr/lib/jenkins/jenkins.war
ENV INSTALL_PLUGINS="git-client:2.8.6,htmlpublisher:1.21,script-security:1.66,workflow-aggregator:2.6"
USER 0
