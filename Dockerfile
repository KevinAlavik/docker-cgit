FROM centos:7
# Maintainers
MAINTAINER Robin Dietrich <me@invokr.org>, Kevin Alavik <kevin@alavik.se>

# Htaccess credentials
ENV HTTP_AUTH_USER="" HTTP_AUTH_PASSWORD=""

# Upgrade base system
RUN yum update -y && yum install -y \
    gcc git httpd highlight make nginx openssl-devel \
    && yum clean all

# Install cgit
RUN git clone https://git.zx2c4.com/cgit && cd cgit \
    && git submodule init && git submodule update \
    && make NO_LUA=1 && make install \
    && cd .. && rm -Rf cgit

# Configure
ADD config/httpd.conf /etc/httpd/conf/httpd.conf
ADD config/cgit.conf /etc/cgitrc
ADD scripts /opt

# Install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Expose port 80
EXPOSE 80

# Start the application
CMD ["/usr/local/bin/dumb-init", "/opt/init.sh"]
