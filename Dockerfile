FROM rocker/shiny:4 AS builder

RUN R -e "install.packages(c('remotes', 'DT', 'zoo', 'shinydashboard', 'dplyr', 'dbplyr', 'plotrix', 'ggplot2', 'lubridate', 'stringr', 'shinyjs', 'leaflet'), repos='http://cran.rstudio.com/')"

WORKDIR /build

COPY DESCRIPTION NAMESPACE ./
COPY R/ ./R

COPY . .

RUN R -e "remotes::install_local(upgrade = 'never')"

FROM rocker/shiny:4

COPY --from=builder /usr/local/lib/R/site-library/ /usr/local/lib/R/site-library/

RUN rm -rf /srv/shiny-server/*

COPY --from=builder /usr/local/lib/R/site-library/swedishbirdrecoveries/shiny-apps/birdrecoveries/ /srv/shiny-server/

EXPOSE 3838

