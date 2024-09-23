FROM alpine:latest

# Maintainers
MAINTAINER Robin Dietrich <me@invokr.org>, Kevin Alavik <kevin@alavik.se>

# Htaccess credentials
ENV HTTP_AUTH_USER="" HTTP_AUTH_PASSWORD=""

# Install necessary packages
RUN apk update && apk add --no-cache \
    gcc git nginx highlight make openssl-dev \
    && apk add --no-cache --virtual .build-deps \
    musl-dev linux-headers

# Install cgit
RUN git clone https://git.zx2c4.com/cgit && cd cgit \
    && git submodule init && git submodule update \
    && make NO_LUA=1 && make install \
    && cd .. && rm -rf cgit \
    && apk del .build-deps
    
# Configure Nginx and CGit
COPY config/httpd.conf /etc/nginx/nginx.conf
COPY config/cgit.conf /etc/cgitrc
COPY scripts /opt

# Install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Expose port 80
EXPOSE 80

# Start Nginx and CGit
CMD ["/usr/local/bin/dumb-init", "nginx", "-g", "daemon off;"]
