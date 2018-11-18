FROM ubuntu:18.04

MAINTAINER Marko Lerota <mlerota@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# install Nginx and PHP modules
RUN apt-get update && apt-get install -y nginx php php-gettext php-tcpdf php-pear php-imagick php-memcache php-sqlite3 \
    	    php-xdebug php7.2-cli php7.2-common php7.2-cgi php7.2-curl php7.2-dev php7.2-fpm php7.2-gd php7.2-json \
	    php7.2-ldap php7.2-mysql php7.2-readline php7.2-snmp php7.2-soap php7.2-tidy php7.2-xmlrpc php7.2-xsl pkg-php-tools 

# Clean after install 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

# Modify PHP settings
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf
ADD php/php-development.ini /etc/php/7.2/fpm/php.ini
ADD php/www.conf /etc/php/7.2/fpm/pool.d/www.conf

# Modify Nginx config
RUN rm /etc/nginx/sites-enabled/default
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/server /etc/nginx/conf.d/server
ADD nginx/http /etc/nginx/conf.d/http
ADD nginx/site.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/site.conf /etc/nginx/sites-enabled/site.conf

# Add phpinfo and index.html page
ADD php/phpinfo.php /var/www/html
ADD nginx/index.html /var/www/html

RUN mkdir /var/www/sites/
ADD artifact /var/www/sites/kube-test1
# Before building from this Dockerfile, create your secret .env file like this:
# kubectl create secret generic yoursecretname --from-file=./dot_env
# Then check wp-deployment.yml for mounting the secret into kubernetes pod
RUN ln -s /etc/wp-secrets/dot_env /var/www/sites/kube-test1/.env

# Forward request and error logs to log collector
#RUN ln -sf /dev/stdout /var/log/nginx/access.log \
#        && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose ports
EXPOSE 8000

# Define default command.
CMD service php7.2-fpm start && nginx
