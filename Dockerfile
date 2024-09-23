FROM alpine:latest

# Maintainers
MAINTAINER Robin Dietrich <me@invokr.org>, Kevin Alavik <kevin@alavik.se>

# Htaccess credentials
ENV HTTP_AUTH_USER="" HTTP_AUTH_PASSWORD=""

# Install necessary packages
RUN apk update && apk add --no-cache \
    gcc git httpd apache2-utils highlight make openssl-dev zlib-dev \
    && apk add --no-cache --virtual .build-deps \
    musl-dev linux-headers

# Install cgit
RUN git clone https://git.zx2c4.com/cgit && cd cgit \
    && git submodule init && git submodule update \
    && make NO_LUA=1 NO_REGEX=NeedsStartEnd && make install \
    && cd .. && rm -rf cgit \
    && apk del .build-deps

# Copy configuration files for Apache and CGit
COPY config/httpd.conf /etc/httpd/httpd.conf
COPY config/cgit.conf /etc/cgitrc
COPY scripts /opt

# Set up the document root
RUN mkdir -p /var/www/htdocs/cgit

# Install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Expose port for HTTP
EXPOSE 80

# Start Apache HTTP Server
CMD ["/usr/local/bin/dumb-init", "httpd", "-D", "FOREGROUND"]
