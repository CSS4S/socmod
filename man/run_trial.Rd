% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trial.R
\name{run_trial}
\alias{run_trial}
\title{Trial runner helper function}
\usage{
run_trial(
  model,
  stop = socmod::fixated,
  legacy_behavior = "Legacy",
  adaptive_behavior = "Adaptive",
  metadata = list()
)
}
\arguments{
\item{model}{An AgentBasedModel}

\item{stop}{Stopping condition: max steps (int) or predicate function}

\item{adaptive_behavior}{The behavior treated as "adaptation success". Default is "Adaptive".}
}
\value{
A Trial object
}
\description{
Trial runner helper function
}
\examples{
agents <- list(
  Agent$new(name = "1", behavior = "Legacy", fitness = 1),
  Agent$new(name = "2", behavior = "Adaptive", fitness = 4)
)
net <- igraph::make_graph(~ 1-2)
model <- AgentBasedModel$new(agents = agents, graph = net)
trial <- run_trial(model, stop = 10)
}
