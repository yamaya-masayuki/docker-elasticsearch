FROM centos:centos7
MAINTAINER The ViaQ Community <community@TBA>

EXPOSE 9200
EXPOSE 9300
USER 0

ENV HOME=/opt/app-root/src \
  JAVA_VER=1.8.0 \
  ES_VER=1.5.2 \
  ES_HOME=/usr/share/elasticsearch \
  ES_CONF=${ES_HOME}/config/elasticsearch.yml \
  INSTANCE_RAM=8G \
  NODE_QUORUM=1 \
  RECOVER_AFTER_NODES=1 \
  RECOVER_EXPECTED_NODES=1 \
  RECOVER_AFTER_TIME=5m \
  PLUGIN_LOGLEVEL=INFO

LABEL io.k8s.description="Elasticsearch container for allowing indexing and searching of aggregated logs" \
  io.k8s.display-name="Elasticsearch ${ES_VER}" \
  io.openshift.expose-services="9200:https, 9300:https" \
  io.openshift.tags="logging,elk,elasticsearch"

ADD elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
ADD run.sh install.sh ${HOME}/
ADD *.yml /usr/share/elasticsearch/config/
ADD index_templates /usr/share/elasticsearch/config/index_templates
RUN ${HOME}/install.sh

WORKDIR ${HOME}
USER 1000
CMD ["sh", "/opt/app-root/src/run.sh"]
