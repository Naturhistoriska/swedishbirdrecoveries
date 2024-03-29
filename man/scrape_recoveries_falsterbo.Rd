% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scrape.R
\name{scrape_recoveries_falsterbo}
\alias{scrape_recoveries_falsterbo}
\title{Retrieve bird recovery data from Falsterbo Fågelstation}
\usage{
scrape_recoveries_falsterbo(species = "ACNIS")
}
\arguments{
\item{species}{the scientific name for a bird species}
}
\value{
a data frame with recovery data
}
\description{
Retrieve bird recovery data from Falsterbo Fågelstation
}
\examples{
df <- scrape_recoveries_falsterbo()
}
