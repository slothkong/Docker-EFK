FROM docker.elastic.co/elasticsearch/elasticsearch:6.7.0


WORKDIR /usr/share/elasticsearch
COPY plugins/analysis-nori-6.4.3.zip /

# install `elasticsearch-analysis-seunjeon`
RUN ./bin/elasticsearch-plugin install file:///analysis-nori-6.4.3.zip

RUN echo 'path.repo: ["/opt/elasticsearch/backup"]' >> /usr/share/elasticsearch/config/elasticsearch.yml
RUN mkdir -p /opt/elasticsearch/backup

RUN  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
RUN  chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/logs
RUN  chown -R elasticsearch:elasticsearch /opt/elasticsearch/backup

EXPOSE 9200
