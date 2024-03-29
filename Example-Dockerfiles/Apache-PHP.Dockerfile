# Example Dockerfile that uses sudo to run a service that needs to bind to a privileged port
# This is accepted for services with known-good sandboxing, like Apache/nginx.
# This is less accepted for random shit.

# Rename to 'Dockerfile'

# Use alpine for its efficiency and small attack surface.
FROM alpine:latest

# Add a low priv user.
RUN adduser -S -s /bin/false -H -D user

# Install apache, php and sudo
RUN apk add apache2 apache2-ctl php7-apache2 sudo

# Name the server
RUN echo "ServerName wactf" >> /etc/apache2/httpd.conf

# Whitelist the sudo command to allow user to run apache, but nothing else as root.
RUN echo "user ALL = (ALL) NOPASSWD: /usr/sbin/apachectl -D FOREGROUND" > /etc/sudoers.d/user

# Copy warez into the web root
COPY ./src/ /var/www/localhost/htdocs/

# Uncomment next 2 lines if you are using an index.php
# RUN rm -f /var/www/localhost/htdocs/index.html
# RUN sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/apache2/httpd.conf

# Drop privs
USER user

# Your docker-compose should expose port 80

# Run apache
CMD /usr/bin/sudo /usr/sbin/apachectl -D FOREGROUND