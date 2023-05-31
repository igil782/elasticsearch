
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget
RUN mkdir /opt/java && \
    wget -qO- --header "Cookie: oraclelicense=accept-securebackup-cookie" --no-check-certificate http://javadl.oracle.com/webapps/download/AutoDL?BundleId=207765 | tar zxv -C /opt/java
ENV JAVA_HOME /opt/java/jre1.8.0_91
RUN export JAVA_HOME
RUN rm -r /var/lib/apt/lists/*
RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 
RUN apt-get install apt-transport-https
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
RUN apt-get update && sudo apt-get install elasticsearch

WORKDIR /usr/share/elasticsearch
COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/
RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done
	
WORKDIR /usr/share/elasticsearch
COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/
RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done
	
USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300




	
