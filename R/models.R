#' Models Client
#'
#' Client for OpenAI Models API.
#'
#' @export
ModelsClient <- R6::R6Class(
  "ModelsClient",
  public = list(
    client = NULL,
    
    #' Initialize models client
    #'
    #' @param parent Parent OpenAI client
    initialize = function(parent) {
      self$client <- parent
    },
    
    #' List available models
    #'
    #' @return Models list response
    list = function() {
      self$client$request("GET", "/models")
    },
    
    #' Retrieve a specific model
    #'
    #' @param model Model ID (e.g., "gpt-4", "text-embedding-ada-002")
    #' @return Model details
    retrieve = function(model) {
      self$client$request("GET", paste0("/models/", model))
    },
    
    #' Delete a fine-tuned model
    #'
    #' @param model Model ID
    #' @return Deletion status
    delete = function(model) {
      self$client$request("DELETE", paste0("/models/", model))
    }
  )
)

#' List models (convenience function)
#'
#' @return Models list
#' @export
list_models <- function() {
  client <- OpenAI$new()
  client$models$list()
}

#' Retrieve a model (convenience function)
#'
#' @param model Model ID
#' @return Model details
#' @export
retrieve_model <- function(model) {
  client <- OpenAI$new()
  client$models$retrieve(model)
}

#' Delete a model (convenience function)
#'
#' @param model Model ID
#' @return Deletion status
#' @export
delete_model <- function(model) {
  client <- OpenAI$new()
  client$models$delete(model)
}
