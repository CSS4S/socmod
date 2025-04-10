% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agent.R
\name{Agent}
\alias{Agent}
\title{Agent for use with AgentBasedModel instances}
\description{
Agent attributes include information about previous, current, and next behaviors,
neighbors (an instance of the Neighbors class). Use class methods
to calculate exposure probability, add neighbors, or set agent fitness.
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{prev_behavior}}{Previous agent behavior.}

\item{\code{curr_behavior}}{Current agent behavior.}

\item{\code{next_behavior}}{Next behavior the agent could do, depending on iterate_model.}

\item{\code{neighbors}}{Initial set of neighbors.}

\item{\code{prev_fitness}}{Previous agent fitness.}

\item{\code{curr_fitness}}{Current agent fitness.}

\item{\code{next_fitness}}{Next fitness.}

\item{\code{name}}{Agent's name.}

\item{\code{group}}{Agent's group.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Agent-new}{\code{Agent$new()}}
\item \href{#method-Agent-add_neighbors}{\code{Agent$add_neighbors()}}
\item \href{#method-Agent-exposure_prob}{\code{Agent$exposure_prob()}}
\item \href{#method-Agent-set_fitness}{\code{Agent$set_fitness()}}
\item \href{#method-Agent-clone}{\code{Agent$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Agent-new"></a>}}
\if{latex}{\out{\hypertarget{method-Agent-new}{}}}
\subsection{Method \code{new()}}{
Create a new Agent instance.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Agent$new(
  behavior = "",
  fitness = 0,
  name = NULL,
  neighbors = c(),
  group = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{behavior}}{Initial agent behavior.}

\item{\code{fitness}}{Agent fitness.}

\item{\code{name}}{Agent name; should be unique or maybe face unexpected problems.}

\item{\code{neighbors}}{Initialize neighbors; typically done in ABM initialization.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new \code{Agent} object.
Add agents to this agent's \code{neighbor} field
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Agent-add_neighbors"></a>}}
\if{latex}{\out{\hypertarget{method-Agent-add_neighbors}{}}}
\subsection{Method \code{add_neighbors()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Agent$add_neighbors(new_neighbors)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{new_neighbors}}{List of Agents to add as neighbors.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
self (Agent)
Calculate the exposure probability for this agent.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Agent-exposure_prob"></a>}}
\if{latex}{\out{\hypertarget{method-Agent-exposure_prob}{}}}
\subsection{Method \code{exposure_prob()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Agent$exposure_prob()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
Float ≥ 0 and ≤ 1 representing the probability of a non-trivial
exposure to the adaptive behavior, where \emph{non-trivial} exposure means the learner
is doing the legacy behavior and selects an agent doing the adaptive behavior.
Set the agent's current fitness value.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Agent-set_fitness"></a>}}
\if{latex}{\out{\hypertarget{method-Agent-set_fitness}{}}}
\subsection{Method \code{set_fitness()}}{
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Agent$set_fitness(fitness)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{fitness}}{The fitness to assign.}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
self
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Agent-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Agent-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Agent$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
