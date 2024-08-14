#!/bin/bash

# Путь к файлу connections
CONNECTIONS_FILE="/home/jovyan/configs/connections"

# Считывание значений из файла connections
source $CONNECTIONS_FILE

# Создание файла spark-defaults.conf с необходимыми настройками
SPARK_CONF_DIR="/usr/local/spark/conf"
SPARK_DEFAULTS_CONF="$SPARK_CONF_DIR/spark-defaults.conf"

echo "spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem" > $SPARK_DEFAULTS_CONF
echo "spark.hadoop.fs.s3a.endpoint=$endpoint" >> $SPARK_DEFAULTS_CONF
echo "spark.hadoop.fs.s3a.access.key=$access_key" >> $SPARK_DEFAULTS_CONF
echo "spark.hadoop.fs.s3a.secret.key=$secret_key" >> $SPARK_DEFAULTS_CONF
echo "spark.hadoop.fs.s3a.path.style.access=true"
