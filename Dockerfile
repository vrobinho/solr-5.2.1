FROM vrobinho/centos6.9-jdk7

RUN yum update -y && \
	yum install -y wget && \
	yum clean all

ENV SOLR_USER="solr" \
	SOLR_GROUP="solr" \
	SOLR_URL="http://archive.apache.org/dist/lucene/solr/5.2.1/solr-5.2.1.tgz" \
    SOLR_SHA256="0351906cdeef48cdc85b3fe75dc5c038a90bae5f" \
	PATH="/opt/solr/bin:$PATH"
	
RUN groupadd -r $SOLR_GROUP && \
    useradd -r $SOLR_USER -g $SOLR_GROUP
	
RUN mkdir -p /opt/solr && \
  echo "downloading $SOLR_URL" && \
  wget -nv $SOLR_URL -O /opt/solr.tgz && \
  echo "downloading $SOLR_URL.asc" && \
  wget -nv $SOLR_URL.asc -O /opt/solr.tgz.asc && \
  tar -C /opt/solr --extract --file /opt/solr.tgz --strip-components=1 && \
  rm /opt/solr.tgz* && \
  rm -Rf /opt/solr/docs/
  
COPY scripts/* /opt/solr/bin/

RUN chmod -R 755 /opt/solr && \
    chown -R $SOLR_USER:$SOLR_GROUP /opt/solr

USER $SOLR_USER

CMD ["solr-cloud-zk"] 