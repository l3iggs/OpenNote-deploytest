FROM base/archlinux
MAINTAINER l3iggs <l3iggs@live.com>

# update
RUN pacman -Suy --noconfirm

# install packaging deps
RUN pacman -Suy --noconfirm --needed unzip

# Install runtime deps
RUN pacman -Suy --noconfirm --needed apache php php-apache mariadb

# setup apache with ssl, php and mysql enabled
RUN sed -i 's,#LoadModule ssl_module modules/mod_ssl.so,LoadModule ssl_module modules/mod_ssl.so\nLoadModule php5_module modules/libphp5.so,g' /etc/httpd/conf/httpd.conf
RUN sed -i 's,LoadModule mpm_event_module modules/mod_mpm_event.so,LoadModule mpm_prefork_module modules/mod_mpm_prefork.so,g' /etc/httpd/conf/httpd.conf
RUN echo "Include conf/extra/php5_module.conf" >> /etc/httpd/conf/httpd.conf
RUN sed -i 's,;extension=pdo_mysql.so,extension=pdo_mysql.so,g' /etc/php/php.ini

# extract opennote package
RUN mkdir /app
RUN rm /OpenNote.zip
ADD https://github.com/FoxUSA/OpenNote/releases/download/14.07.02/OpenNote.zip /
RUN unzip /OpenNote.zip -d /app/

# Clean up
RUN rm /app/OpenNote.zip
RUN rm /app/Service/Config.*
RUN rm /app/Service/install.php

# Add pre-made config and setup script
ADD ./Config.php /app/Service/
ADD ./create_mysql_admin_user.sh /

# Set permissions
RUN chmod 755 /app -R
RUN chown http:http /app -R
RUN chmod 755 /*.sh

# move deployment to served directory
RUN mv /app/* /srv/http/.

# Open webservice ports
EXPOSE 80 443


# Start the LAMP stack

