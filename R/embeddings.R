#' Embeddings Client
#'
#' Client for OpenAI Embeddings API.
#'
#' @export
EmbeddingsClient <- R6::R6Class(
  "EmbeddingsClient",
  public = list(
    client = NULL,
    
    #' Initialize embeddings client
    #'
    #' @param parent Parent OpenAI client
    initialize = function(parent) {
      self$client <- parent
    },
    
    #' Create embeddings for text
    #'
    #' @param input Input text or array of texts
    #' @param model Model to use (e.g., "text-embedding-ada-002")
    #' @param encoding_format Format for embeddings ("float" or "base64")
    #' @param dimensions Number of dimensions for embeddings
    #' @param user Unique identifier for end user
    #' @return Embeddings response
    create = function(input, model = "text-embedding-ada-002",
                      encoding_format = NULL,
                      dimensions = NULL,
                      user = NULL) {
      body <- list(
        input = input,
        model = model
      )
      
      if (!is.null(encoding_format)) body$encoding_format <- encoding_format
      if (!is.null(dimensions)) body$dimensions <- dimensions
      if (!is.null(user)) body$user <- user
      
      self$client$request("POST", "/embeddings", body = body)
    }
  )
)

#' Create embeddings (convenience function)
#'
#' @param input Input text or texts
#' @param model Model to use
#' @param ... Additional parameters
#' @return Embeddings response
#' @export
create_embedding <- function(input, model = "text-embedding-ada-002", ...) {
  client <- OpenAI$new()
  client$embeddings$create(input = input, model = model, ...)
}
