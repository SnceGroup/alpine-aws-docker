#!/bin/sh

set -u

# Dockerhub base image
BASE=sncegroup/alpine-aws-docker

# Image Tag passed as argument
VERSION=$1

# Target image
TARGET=${2:-base}

# Check all the published tags
TAGS=$(curl -L -s 'https://registry.hub.docker.com/v2/repositories/sncegroup/alpine-aws-docker/tags?page_size=1024' |jq -r '[ .results[].name ]| @text')

# Asks for confirmation before tagging
echo ""
echo "Building new image version!"
echo "---------------------------"
echo
echo "Current available tags: $TAGS"
echo "You are going to tag this image as $BASE:$VERSION using stage \"$TARGET\""
echo
read -p "Are you sure? [yn] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Skipped, bye!"
    exit 1
fi

# Building the Docker image
echo "Building..."
TAG=${BASE}:${VERSION}

docker build . \
   -f ./Dockerfile \
   -t ${TAG} \
   --target ${TARGET} 

docker tag ${BASE}:${VERSION} ${BASE}:latest
docker push ${BASE}:${VERSION}
docker push ${BASE}:latest

echo "Done!"

