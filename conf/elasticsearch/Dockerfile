FROM bitnami/elasticsearch
USER root
#ADD conf/elasticsearch.yml /bitnami/elasticsearch/config/elasticsearch.yml
RUN mkdir -p /var/lib/apt/lists/partial
RUN apt-get update
RUN apt-get install -y gnupg2 git
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN git clone git://github.com/mobz/elasticsearch-head.git
#RUN cd elasticsearch-head
WORKDIR /elasticsearch-head
RUN npm install
#RUN npm run start
USER 1001