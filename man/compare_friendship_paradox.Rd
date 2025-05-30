% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/networks.R
\name{compare_friendship_paradox}
\alias{compare_friendship_paradox}
\title{Compare Friendship Paradox in a Network}
\usage{
compare_friendship_paradox(graph, return_node_data = FALSE)
}
\arguments{
\item{graph}{An \code{igraph} or \code{tidygraph::tbl_graph} object representing an undirected network.}

\item{return_node_data}{Logical. If TRUE, includes a data frame with node-level results.}
}
\value{
A list with:
\itemize{
\item \code{paradox_proportion}: Proportion of nodes experiencing the friendship paradox
\item \code{summary}: A data frame with average degree and average neighbor degree
\item \code{nodes}: (Optional) A data frame with node-level metrics if \code{return_node_data = TRUE}
}
}
\description{
For each node, compares the number of friends (degree) to the mean number
of friends among their neighbors. Calculates the proportion of nodes
that have fewer friends than the average of their friends (the friendship paradox).
}
\details{
Supports both \code{igraph} and \code{tidygraph::tbl_graph} inputs.
}
\examples{
\dontrun{
# Use with an igraph network
library(igraph)
g_ig <- simulate_feld_1991()
compare_friendship_paradox(g_ig)

# Return node-level metrics too
result2 <- compare_friendship_paradox(g, return_node_data = TRUE)
head(result2$nodes)
}
}
