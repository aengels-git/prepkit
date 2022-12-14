% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep_mean_table.R
\name{prep_mean_table}
\alias{prep_mean_table}
\title{prep_mean_table}
\usage{
prep_mean_table(data, ..., outcomes, weight = NULL, gather = F, digits = 2)
}
\arguments{
\item{data}{dataset}

\item{...}{arbitrary number of grouping variables}

\item{outcomes}{one or more numeric outcome variables}

\item{weight}{optional vector of weights for weighted mean / and std}

\item{gather}{change to long format}

\item{digits}{number of digits to round to}
}
\description{
prep_mean_table
}
\examples{
library(ggplot2)
prep_mean_table(diamonds,cut,color,outcomes=c("price"))

}
