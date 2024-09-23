CGit Docker
=================

Fork of https://github.com/invokr/docker-cgit in hopes to revive it

Running the container
----------------------

    docker pull invokr/cgit
    docker run -name cgit -d -p 80:80 -v my/git/repositories:/git invokr/cgit

Optional authentication via htaccess:

    docker run -name cgit -d -p 80:80 -e HTTP_AUTH_USER=user -e HTTP_AUTH_PASSWORD=password -v my/git/repositories:/git invokr/cgit
