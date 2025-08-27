FROM httpd:latest
MAINTAINER vladimir@goreadmin.ru
WORKDIR /usr/local/apache2/htdocs/


# Устанавливаем Apache Exporter
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/Lusitaniae/apache_exporter/releases/download/v0.10.0/apache_exporter-0.10.0.linux-amd64.tar.gz && \
    tar -xzf apache_exporter-0.10.0.linux-amd64.tar.gz && \
    mv apache_exporter-0.10.0.linux-amd64/apache_exporter /usr/local/bin/ && \
    rm -rf apache_exporter-0.10.0.linux-amd64.tar.gz apache_exporter-0.10.0.linux-amd64


RUN echo "Include conf/extra/apache-status.conf" >> /usr/local/apache2/conf/httpd.conf

# Запускаем Apache и apache_exporter
CMD ["sh", "-c", "httpd-foreground & apache_exporter --scrape_uri=http://localhost/server-status?auto"]

# Порты: 80 для Apache и 9117 для экспорта метрик
EXPOSE 80 9117
