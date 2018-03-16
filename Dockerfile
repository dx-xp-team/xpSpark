FROM ubuntu:14.04
RUN apt-get update
RUN apt-get -y install libatlas-base-dev gfortran
RUN apt-get -y install python-dev
RUN apt-get -y install python-pip; apt-get clean all
RUN pip install --upgrade pip scipy numpy pandas scikit-learn keras
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.6.0-cp34-cp34m-linux_x86_64.whl
RUN apt-get -y install java-1.8.0-openjdk; apt-get clean all
RUN curl -s https://www.apache.org/dyn/closer.lua/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz | tar xz -C /opt
RUN ln -s /opt/spark-2.3.0-bin-hadoop2.7 /opt/spark
WORKDIR /opt/spark
RUN cp /opt/spark/conf/spark-defaults.conf.template /opt/spark/conf/spark-defaults.conf
RUN echo 'spark.driver.extraJavaOptions=-Dhttp.proxyHost=http://proxy.lbs.alcatel-lucent.com -Dhttp.proxyPort=8000 -Dhttps.proxyHost=http://proxy.lbs.alcatel-lucent.com -Dhttps.proxyPort=8000' >> /opt/spark/conf/spark-defaults.conf
RUN echo 'spark.ui.reverseProxy true' >> /opt/spark/conf/spark-defaults.conf
