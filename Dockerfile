# Multistage build to reduce image size and increase security
FROM node:12-stretch-slim AS build

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
FROM node:12-stretch-slim

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

# Port
EXPOSE 3000

# Run cryptpad on startup
CMD ["server.js"]
