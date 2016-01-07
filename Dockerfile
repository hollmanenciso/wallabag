FROM ubuntu:latest
MAINTAINER Hollman Enciso <hollman.enciso@gmail.com>
RUN apt-get update && apt-get -y dist-upgrade

#Install the neccesary packages
RUN apt-get -y install apache2 php5 php5-gd php5-imap php5-mcrypt php5-memcached php5-mysql mysql-client php5-curl php5-tidy php5-sqlite curl wget unzip

#Downloading elgg code
RUN wget -qO /tmp/elgg.zip https://elgg.org/getelgg.php?forward=elgg-2.0.1.zip
RUN rm -fr /var/www/html
RUN unzip /tmp/elgg.zip  -d /tmp/
RUN rm /tmp/elgg.zip
RUN mv /tmp/elgg-* /var/www/html

#configuring apache

RUN a2enmod rewrite
RUN mkdir /var/www/html/data
RUN chown -R www-data.www-data /var/www/html


#setting the document root volume
VOLUME ["/var/www/html/"]

#Set some apache variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

#Expose default apache port
EXPOSE 80

#run apache on background
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
