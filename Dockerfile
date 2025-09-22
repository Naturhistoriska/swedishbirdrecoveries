FROM rocker/shiny:4

# Install required R packages
RUN R -e "install.packages( \
    c('DT','zoo','remotes','shinydashboard','dplyr','dbplyr','plotrix','ggplot2','lubridate','stringr','shinyjs'), \
    repos='http://cran.rstudio.com/')"

# Copy your package and install
COPY . /tmp/swedishbirdrecoveries

RUN R -e "remotes::install_local('/tmp/swedishbirdrecoveries')"

# Remove default shiny-server landing page and sample apps,
# then copy YOUR shiny app to root (/)
RUN rm -f /srv/shiny-server/index.html && \
    rm -rf /srv/shiny-server/sample-apps && \
    cp -r /usr/local/lib/R/site-library/swedishbirdrecoveries/shiny-apps/birdrecoveries/* /srv/shiny-server/

# Expose Shiny port
EXPOSE 3838
