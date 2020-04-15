FROM rocker/shiny:3.6.1

RUN rm -vfr /var/lib/apt/lists/*
COPY ./sources.list /etc/apt/sources.list

RUN sudo apt-get update && apt-get install -y \
         nano \
         libssl-dev \
         libxml2-dev \
         libtiff-dev \
         libjpeg-dev

# So nano works
ENV TERM xterm

# custom packages
RUN sudo su - -c "R -e \"install.packages(c('DT','zoo','devtools','shinydashboard','dplyr','plotrix','ggplot2','lubridate','stringr','shinyjs'), repos='http://cran.rstudio.com/')\""

RUN sudo su - -c "R -e \"devtools::install_github('Naturhistoriska/swedishbirdrecoveries')\""

# avoid shiny-startup page and to deploy the birdrecoveries 
RUN rm /srv/shiny-server/index.html && \
	rm -rf /srv/shiny-server/sample-apps && \
	ln -s /usr/local/lib/R/site-library/swedishbirdrecoveries/shiny-apps/birdrecoveries/* /srv/shiny-server