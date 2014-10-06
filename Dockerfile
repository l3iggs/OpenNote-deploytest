# Created by Jake Liscom (C) 2014
# Include LAMP stack
FROM tutum/lamp:latest

# Install dependencies
RUN apt-get install wget unzip

# OpenNote install command
RUN rm -fr /app
RUN wget https://github.com/FoxUSA/OpenNote/releases/download/14.07.02/OpenNote.zip -P /app
RUN unzip /app/OpenNote.zip -d /app

# Clean up
RUN rm /app/OpenNote.zip
RUN rm /app/Service/Config.*
RUN rm /app/Service/install.php

# Add pre-made config and setup script
ADD ./Config.php /app/Service/
ADD ./create_mysql_admin_user.sh /

# Set permissions
RUN chmod 755 /app -R
RUN chown www-data:www-data /app -R
RUN chmod 755 /*.sh

# Open webservice ports
EXPOSE 80 443

# Start the LAMP stack
CMD ["/run.sh"]