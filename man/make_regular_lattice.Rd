% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/networks.R
\name{make_regular_lattice}
\alias{make_regular_lattice}
\title{Create a regular lattice graph.}
\usage{
make_regular_lattice(N, k, directed = FALSE)
}
\arguments{
\item{N}{number of nodes}

\item{k}{node degree}

\item{directed}{Whether the graph should be directed}
}
\value{
igraph Graph
}
\description{
Adapted from
https://github.com/USCCANA/netdiffuseR/blob/1efc0be4539d23ab800187c73551624834038e00/src/rgraph.cpp#L90
Difference here is we'll only use undirected for now, so need to adjust by
default (see also NetLogo routine in Smaldino Ch. 9 p. 266).
Because igraph is flexible, it will add duplicate edges, so we have to check
to make sure an edge does not exist between two nodes before adding it, using
the \code{igraph::are_adjacent} function ("adjacent" means there is an edge between two
nodes in an undirected graph–in a directed graph the definition is subjective,
i.e., v1 and v2 are sometimes defined as adjacent if there's an edge from
v1 to v2, and others define adjacency as an edge from v2 to v1).
}
\examples{
# Make a 10-node lattice with nodes degree 4.
net <- make_regular_lattice(10, 4)
plot(net)
}
