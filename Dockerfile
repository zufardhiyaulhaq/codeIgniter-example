From ubuntu:16.04

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main"  >> /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt -y install tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
RUN apt-get -y --allow-unauthenticated install apache2 \
    php5.6 \
    libapache2-mod-php5.6 \
    php5.6-mbstring  \
    php5.6-mcrypt \
    php5.6-xml \
    php5.6-gd \
    php5.6-mysql
ADD apps /var/www/html/
ADD vhost.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2dissite 000-default.conf && a2ensite vhost.conf
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

