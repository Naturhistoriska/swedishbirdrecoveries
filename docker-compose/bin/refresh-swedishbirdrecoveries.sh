#!/bin/bash

docker exec shiny \
Rscript /usr/local/lib/R/site-library/swedishbirdrecoveries/exec/update_data.R

docker restart shiny
