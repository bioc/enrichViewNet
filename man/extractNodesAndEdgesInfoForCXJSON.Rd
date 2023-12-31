% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methodsInternal.R
\encoding{UTF-8}
\name{extractNodesAndEdgesInfoForCXJSON}
\alias{extractNodesAndEdgesInfoForCXJSON}
\title{Extract information about nodes and edges}
\usage{
extractNodesAndEdgesInfoForCXJSON(gostResults, gostObject)
}
\arguments{
\item{gostResults}{a \code{data.frame} containing the terms retained
for the creation of the network.}

\item{gostObject}{a \code{list} created by gprofiler2 that contains
the results from an enrichment analysis.}
}
\value{
a \code{list} containing 4 entries:
\itemize{
\item{"nodes"}{a \code{data.frame} containing the information about
the nodes present in the network.}
\item{"edges"}{a \code{data.frame} containing the information about
the edges present in the network.}
\item{"nodeAttributes"}{a \code{data.frame} containing the attributes
associated to the nodes present in the network.}
\item{"edgesAttributes"}{a \code{data.frame} containing the attributes
associated to the edges present in the network}
}
}
\description{
Extract information about nodes and edges that is necessary
to create the CX JSON text representing the network
}
\examples{

## Loading dataset containing result from an enrichment analysis done with
## gprofiler2
data(demoGOST)

## Only retained the WikiPathways results
results <- demoGOST$result[demoGOST$result$source == "WP", ]

information <- enrichViewNet:::extractNodesAndEdgesInfoForCXJSON(
                gostResults=results, gostObject=demoGOST)

}
\author{
Astrid Deschênes
}
\keyword{internal}
