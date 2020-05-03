# Multistage build to reduce image size and increase security
FROM node:12-buster-slim AS build

# Install requirements to clone repository and install deps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq git
RUN npm install -g bower

# Allow to create docker image from different repository or branch
ARG REPO=https://github.com/xwiki-labs/cryptpad.git
ARG BRANCH=master

# Create folder for cryptpad
RUN mkdir /cryptpad
WORKDIR /cryptpad

# Get cryptpad from upstream
RUN git clone --depth 1 --branch ${BRANCH} --single-branch ${REPO} .\
    && rm -rf .git

# Install dependencies
RUN npm install --production \
    && npm install -g bower \
    && bower install --allow-root

# Create actual cryptpad image
FROM node:12-buster-slim

# Create user and group for cryptpad so it does not run as root
RUN groupadd cryptpad -g 4001
RUN useradd cryptpad -u 4001 -g 4001 -d /cryptpad

# Copy cryptpad with installed modules
COPY --from=build --chown=cryptpad /cryptpad /cryptpad
USER cryptpad

# Create directory for data
RUN mkdir /cryptpad/data

# Copy customizations into the container
COPY --chown=cryptpad customize /cryptpad/customize

# Set workdir to cryptpad
WORKDIR /cryptpad

# Volumes for data persistence
VOLUME /cryptpad/datastore
VOLUME /cryptpad/data
VOLUME /cryptpad/block
VOLUME /cryptpad/blob

# Ports
EXPOSE 3000 3001

# Run cryptpad on startup
CMD ["server.js"]
