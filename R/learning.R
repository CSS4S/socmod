#' LearningStrategy
#'
#' Represents a reusable learning strategy composed of a partner selection function,
#' an interaction function, and a descriptive label.
#'
#' @export
LearningStrategy <- R6::R6Class(
  "LearningStrategy",
  public = list(
    #' @description Create a new LearningStrategy
    #' @param partner_selection Function to select the teacher (or NULL)
    #' @param interaction Function to define the interaction (or NULL)
    #' @param label A string label for this strategy
    initialize = function(partner_selection, interaction, model_step, label) {
      private$.partner_selection <- partner_selection
      private$.interaction <- interaction
      private$.model_step <- model_step
      private$.label <- label
    },
    
    #' @description Get the partner selection function
    #' @return Function
    get_partner_selection = function() {
      return (private$.partner_selection)
    },
    
    #' @description Get the interaction function
    #' @return Function
    get_interaction = function() {
      return (private$.interaction)
    },
    
    #' @description Get the interaction function
    #' @return Function
    get_model_step = function() {
      return (private$.model_step)
    },
    
    #' @description Get the strategy label
    #' @return Character string
    get_label = function() {
      return (private$.label)
    }
  ),
  
  private = list(
    .partner_selection = NULL,
    .interaction = NULL,
    .model_step = NULL,
    .label = NULL
  )
)


#' Factory function for creating a LearningStrategy
#'
#' @param partner_selection Function to select a partner for any `focal_agent` in the `model`.
#' @param interaction Function for interaction between any `focal_agent` and `partner` in the `model`.
#' @param model_step Step function for `model` run after all agents select partner and interact.
#' @param label Character label for this strategy.
#'
#' @return A `LearningStrategy` instance containing social update functions and a metadata-friendly label.
#'
#' @examples
#' success_bias_strategy <- make_learning_strategy(
#'   partner_selection = success_bias_select_teacher,
#'   interaction = success_bias_interact,
#'   label = "Success-biased"
#' )
#' # Mock a partner selection, interaction, and model step to show custom use.
#' mock_selection <- function (focal_agent) NULL
#' mock_interaction <- function (focal_agent, partner, model) NULL
#' mock_model_step <- function (model) NULL
#' mock_strategy <- make_learning_strategy(mock_selection, mock_interaction,
#'                                         mock_model_step, label = "mock")
#' # Note make_learning_strategy wraps the R6 class constructor:
#' mock_strategy_2 <- LearningStrategy$new(mock_selection, mock_interaction,
#'                                         mock_model_step, mock_strategy) 
#' 
#' @export
make_learning_strategy <- function(partner_selection, 
                                   interaction, 
                                   model_step = NULL, 
                                   label = "unlabelled") {
  return (
    LearningStrategy$new(
      partner_selection, interaction, model_step, label
    )
  )
}


#' Make a dummy learning strategy for mockups and testing.
#' 
#' @export
dummy_learning_strategy <- function() {
  return (
    make_learning_strategy(
      partner_selection = \() NULL,
      interaction = \() NULL,
      label = "DummyStrategy"
    )
  )
}


#' A generic method for iterating a learning model, setting the current 
#' behavior and fitness to be whatever was identified as the next behavior
#' and fitness.
#'
#' @return NULL Operates in-place to update all agent's behavior if necessary.
#' @export
iterate_learning_model <- function(model) {
  for (agent in model$agents) {
    agent$set_behavior(agent$get_next_behavior())
    agent$set_fitness(agent$get_next_fitness())
  }
}

#' More modern v0.1 alias for iterate_learning_model.
#' @export
#' 
learning_model_step <- iterate_learning_model



### ------ FREQUENCY BIAS --------

#' Frequency biased teacher selection does nothing
#'
#' @return NULL
#' @export
frequency_bias_select_teacher <- function(agent, model) { return (NULL) }


#' Interaction function for frequency-biased adaptive learning.
#'
#' @param learner Agent currently selected as learner.
#' @param . Not used (no teacher for frequency bias).
#' @param model The ABM instance
#' @return NULL 
#' @export
frequency_bias_interact <- function(learner, ., model) {
  
  # If learner is not stubborn (i.e., receptive) this round, 
  # skip social learning.
  stubbornness <- learner$get_attribute("stubbornness")
  receptive <- TRUE
  
  if (!is.null(stubbornness)) {
    receptive <- 
      runif(1) > learner$get_attribute("stubbornness")
  }
  
  if (receptive) {
    
    behaviors <- 
      learner$get_neighbors()$map(\(a) a$get_behavior())
    
    behavior_counts <- 
      table(as.character(behaviors)) |> as.data.frame()
    
    names(behavior_counts) <- c("curr_behavior", "n")
    
    behavior_counts$selection_prob <- 
      behavior_counts$n / sum(behavior_counts$n)
    
    selected <- 
      sample(behavior_counts$curr_behavior, 1, 
             prob = behavior_counts$selection_prob)[[1]]
  
    learner$set_next_behavior(as.character(selected))
  }
}


### ----- SUCCESS BIAS --------

#' @title Success-biased teacher selection
#' @description Selects the most successful neighbor (highest fitness) to learn from. Ties are broken at random.
#' @param learner An Agent instance evaluating neighbors.
#' @param model An AgentBasedModel instance (not used directly here, but included for consistency with other learning functions).
#' @return An Agent object: the selected teacher.
#' @examples
#' model <- ?
#' learner <- model$get_agent(1)
#' teacher <- success_bias_select_teacher(learner, model)
#' @export
success_bias_select_teacher <- function(learner, model) {
  
  stubbornness <- learner$get_attribute("stubbornness")
  
  # If stubbornness is not used, ignore it and proceed with learning as usual, or
  # check if the learner is stubborn this time, i.e., if a random uniform draw is
  # greater than stubbornness.
  if (is.null(stubbornness) || (runif(1) > stubbornness)) {
  
    learner$get_neighbors()$sample(
      weights = \(a) {
        fitness <- a$get_fitness()
        
        if (!is.numeric(fitness) || length(fitness) != 1 || is.na(fitness)) {
          return (0.0) 
        } else {
          return (fitness)
        }
      }
    )
  } else {
    
    return (NULL)
  }
}


#' Success-biased interaction function
#'
#' @return NULL
#' @export
success_bias_interact <- function(learner, teacher, model) {
  
  # Teacher will be null if learner is stubborn this time, nothing will happen.
  if (!is.null(teacher)) {
    
    learner$set_next_behavior(teacher$get_behavior())
    learner$set_next_fitness(teacher$get_fitness())
  }
}

### -------- CONTAGION -----------

#' Contagion-based partner selection
#'
#' @description Selects one neighbor at random for potential contagion interaction.
#' @param learner An Agent instance.
#' @param model An AgentBasedModel instance.
#' @return A single neighbor Agent.
#' @examples
#' model <- example_model_with_params()
#' learner <- model$get_agent(1)
#' contagion_partner_selection(learner, model)
#' @export
contagion_partner_selection <- function(learner, model) {
  return (learner$get_neighbors()$sample(1))
}


#' Contagion-based interaction
#' 
#' @description Updates learner behavior based on interaction with an Adaptive neighbor.
#' @param learner An Agent instance.
#' @param teacher An Agent instance.
#' @param model An AgentBasedModel instance with parameter "adopt_rate".
#' @return None. Modifies the learner's next behavior and fitness.
#' @examples
#' model <- example_model_with_params(list(adopt_rate = 1.0))
#' learner <- model$get_agent(1)
#' teacher <- model$get_agent(2)
#' learner$set_behavior("Legacy")
#' teacher$set_behavior("Adaptive")
#' contagion_interaction(learner, teacher, model)
#' @export
contagion_interaction <- function(learner, teacher, model) {

  # Extract relevant parameters from the model.
  adoption_rate <- model$get_parameter("adoption_rate")
  legacy_behavior <- model$get_parameter("legacy_behavior")
  adaptive_behavior <- model$get_parameter("adaptive_behavior")

  assertthat::assert_that(
    !is.null(adoption_rate), 
    msg = "Auxiliary model parameter adoption_rate must be defined for contagion interaction."
  )
  if (is.null(legacy_behavior)) {
    legacy_behavior <- "Legacy"
  }
  if (is.null(adaptive_behavior)) {
    adaptive_behavior <- "Adaptive"
  }

  if ((learner$get_behavior() == legacy_behavior) && 
      (teacher$get_behavior() == adaptive_behavior) && 
      (runif(1) < adoption_rate)) {
    
    learner$set_next_behavior(adaptive_behavior)
    learner$set_next_fitness(teacher$get_fitness())
  }
}


#' Contagion model step

#' @description Updates all agents for dropping behavior and advances model state.
#' @param model An AgentBasedModel instance with parameter "drop_rate".
#' @return None. Updates agent behaviors.
#' @export
contagion_model_step <- function(model) {

  # mps <- model$get_parameters()
  drop_rate <- model$get_parameter("drop_rate")
  legacy_behavior <- model$get_parameter("legacy_behavior")
  adaptive_behavior <- model$get_parameter("adaptive_behavior")

  if (!is.null(drop_rate) && (drop_rate > 0)) {
    for (i in seq_along(model$agents)) {
      agent <- model$get_agent(i)
      if ((agent$get_behavior() == adaptive_behavior) && (runif(1) < drop_rate)) {
        agent$set_next_behavior(legacy_behavior)
      }
    }
  }
  
  iterate_learning_model(model)
}


## ------LEARNING STRATEGIES------

#' Define success-biased learning strategy.
#'
#' @export
success_bias_learning_strategy <- make_learning_strategy(
  success_bias_select_teacher, success_bias_interact, 
  learning_model_step, label = "Success-biased"
)


#' Define frequency-biased learning strategy.
#'
#' @export
frequency_bias_learning_strategy <- make_learning_strategy(
  frequency_bias_select_teacher, frequency_bias_interact, 
  learning_model_step, label = "Frequency-biased"
)


#' Define contagion learning "strategy".
#'
#' @export
contagion_learning_strategy <- make_learning_strategy(
  contagion_partner_selection, contagion_interaction, 
  contagion_model_step, label = "Contagion"
)
