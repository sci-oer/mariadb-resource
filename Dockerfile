
FROM marshallasch/base-resource:latest

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.url="https://github.com/sci-oer/c-resource.git"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/c-resource.git"
LABEL org.opencontainers.image.vendor="University of Guelph School of Computer Science"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Java Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the mariadb specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

# setup the man pages
# RUN yes | unminimize

USER root

COPY database.sqlite /opt/wiki/database.sqlite

RUN apt-get update -y && apt-get install -y mariadb-server

# install jupyter dependancies
RUN pip3 install mariadb_kernel


# Install jupyter kernels
RUN python3 -m mariadb_kernel.install

# copy all the builtin jupyter notebooks
COPY builtinNotebooks /builtin/jupyter
RUN chown -R ${UID}:${UID} /builtin /opt/static /opt/wiki

COPY motd.txt /scripts/
RUN chown -R ${UID}:${UID} /scripts

USER ${UNAME}

# these two labels will change every time the container is built
# put them at the end because of layer caching
ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
