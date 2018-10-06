FROM python:3.6
#RUN yum -y install epel-release gcc openssl-devel bzip2-devel make; yum clean all
#RUN yum -y install python-pip; yum clean all && pip install --upgrade pip numpy scipy pandas scikit-learn tensorflow keras

# Install jdk 8
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN apt-get update
RUN apt-get -y install -t jessie-backports openjdk-8-jre-headless

## Install Spark 2.3.0
RUN apt-get -y install curl python3-pip vim
RUN wget -qO- http://mirrors.gigenet.com/apache/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz  | tar xvz -C /opt
RUN ln -s /opt/spark-2.3.1-bin-hadoop2.7 /opt/spark

## Configure pip to get packages from Artifactory
COPY pip.conf /etc/
RUN pip3 install --upgrade pip numpy scipy pandas scikit-learn tensorflow keras lxml xpcore

## Setup s3 communication
COPY aws-java-sdk-1.7.4.jar hadoop-aws-2.7.3.jar /opt/spark/jars/

##Configure Spark
WORKDIR /opt/spark
RUN cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
RUN echo 'spark.driver.extraJavaOptions=-Dhttp.proxyHost=http://proxy.lbs.alcatel-lucent.com -Dhttp.proxyPort=8000 -Dhttps.proxyHost=http://proxy.lbs.alcatel-lucent.com -Dhttps.proxyPort=8000' >> /opt/spark/conf/spark-defaults.conf
RUN echo 'spark.ui.reverseProxy true' >> /opt/spark/conf/spark-defaults.conf

##Configure s3 communication
RUN echo 'spark.hadoop.fs.s3a.proxy.host=proxy.lbs.alcatel-lucent.com' >> /opt/spark/conf/spark-defaults.conf
RUN echo 'spark.hadoop.fs.s3a.proxy.port=8000' >> /opt/spark/conf/spark-defaults.conf
