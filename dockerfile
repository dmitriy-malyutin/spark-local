FROM jupyter/pyspark-notebook:latest
LABEL maintainer="Dmitriy Malyutin d.malyutin@s7.ru"

# Установка необходимых JAR-файлов для работы с S3
USER root

# Скачать и установить необходимые JAR-файлы
RUN curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1000/aws-java-sdk-bundle-1.11.1000.jar && \
    curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar && \
    mv aws-java-sdk-bundle-1.11.1000.jar /usr/local/spark/jars/ && \
    mv hadoop-aws-3.3.1.jar /usr/local/spark/jars/ && \
    chown ${NB_UID}:${NB_GID} /usr/local/spark/jars/aws-java-sdk-bundle-1.11.1000.jar && \
    chown ${NB_UID}:${NB_GID} /usr/local/spark/jars/hadoop-aws-3.3.1.jar

RUN mkdir /home/jovyan/configs
# Копирование файла connections
COPY config /home/jovyan/configs

# Установка Python-библиотек из requirements.txt
RUN pip install --no-cache-dir -r /home/jovyan/configs/requirements.txt

# Настройка переменных окружения
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$SPARK_HOME/bin

# Создание папки для конфигурации Spark
RUN mkdir -p /home/jovyan/spark/conf

# Скрипт для настройки spark-defaults.conf
RUN apt-get update && apt-get install -y dos2unix
COPY setup-spark-defaults.sh /home/jovyan/setup-spark-defaults.sh
RUN dos2unix /home/jovyan/setup-spark-defaults.sh
RUN chmod +x /home/jovyan/setup-spark-defaults.sh

# Открытие порта для Jupyter
EXPOSE 8888
# Открытие порта для SparkUI
EXPOSE 4040

# Запуск скрипта для настройки Spark и Jupyter Notebook
CMD ["/bin/bash", "-c", "/home/jovyan/setup-spark-defaults.sh && start-notebook.sh --NotebookApp.token=''"]
