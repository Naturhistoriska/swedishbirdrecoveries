#!/bin/bash

source .env
echo $VERSION
docker build -t inkimar/shiny:${VERSION} .
