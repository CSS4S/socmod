ModelParameters <- R6::R6Class(
  
  "ModelParameters",
  
  public = list(
    initialize = function(learning_strategy = success_bias_strategy, 
                          graph = NULL, n_agents = NULL,
                          auxiliary = list()) {
      
      private$.learning_strategy <- learning_strategy
      private$.graph <- graph
      private$.n_agents <- n_agents
      private$.auxiliary <- auxiliary
    },
    
    get_learning_strategy = function() {
      return (private$.learning_strategy)
    },

    set_learning_strategy = function(learning_strategy) {
      stopifnot(inherits(learning_strategy, "LearningStrategy"))
      private$.learning_strategy <- learning_strategy

      return (invisible(self))
    },
    
    get_graph = function() {
      return (private$.graph)
    },

    set_graph = function(graph) {
      private$.graph <- graph

      return (invisible(self))
    },
    
    get_n_agents = function() {
      return (private$.n_agents)
    },

    set_n_agents = function(n_agents) {
      private$.n_agents <- n_agents

      return (invisible(self))
    },
    
    get_auxiliary = function() {
      return (private$.auxiliary)
    },
    
    #' Overwrite existing auxiliary parameters.
    #' 
    #' @return self silently
    set_auxiliary = function(params) {
      private$.auxiliary <- params

      return (invisible(self))
    },
    
    #' Add a key-value pair to the auxiliary 
    #' variables.
    #' 
    #' @return self silently
    add_auxiliary = function(key, value) {
      private$.auxiliary[[key]] <- value
      return (invisible(self))
    },
    
    #' Get all parameter values as list
    #'
    #' @return list of parameters
    as_list = function() {

      return (
        modifyList(
          list(
            learning_strategy = self$get_learning_strategy(),
            graph = private$.graph,
            n_agents = self$get_n_agents()
          ),
          self$get_auxiliary() 
      ))
    }
  ),
  
  private = list(
    .learning_strategy = NULL,
    .graph = NULL,
    .n_agents = NULL,
    .auxiliary = list()
  )
)


#' Wrapper for initializing new ModelParameters instance.
#' 
#' @param learning_strategy Learning strategy to use; must be type LearningStrategy
#' @param graph Graph object to use; must inherit igraph
#' @param n_agents Number of agents in the model
#' @param ... Additional model parameters
#' @examples
#' # example code
#' 
#' @export
make_model_parameters <- 
  function(learning_strategy =
             success_bias_learning_strategy, 
           graph = NULL,
           n_agents = NULL,
           ...)   {
  return (
    ModelParameters$new(learning_strategy, graph, n_agents, list(...))  
  )
}


#' Default parameters to create an agent-based model.
DEFAULT_PARAMETERS <- make_model_parameters(
  learning_strategy = NULL, graph = NULL, n_agents = 10, auxiliary = list()
) 
