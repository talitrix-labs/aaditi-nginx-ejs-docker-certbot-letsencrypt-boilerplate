# Use the official Nginx image as the base image
FROM ubuntu:latest

# Install Node.js and npm
RUN apt-get update && apt-get install -y \
    curl sudo \
 && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
 && apt-get install -y nodejs \
 && apt-get install -y nginx \
 && apt-get install -y certbot \
 && apt-get install -y python3-certbot-nginx \
 && apt-get autoclean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

# Setup NGINX and the website
VOLUME /var/log/nginx/log
COPY conf/nginx /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/sub-yourdomain-com.conf /etc/nginx/sites-enabled/sub-yourdomain-com.conf

EXPOSE 80
EXPOSE 443
#EXPOSE 3000

# Copy the Code
# Copy package.json and package-lock.json if they exist
RUN mkdir /ejs-code
COPY ejs-code /ejs-code
WORKDIR /ejs-code
RUN npm install
#
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
#