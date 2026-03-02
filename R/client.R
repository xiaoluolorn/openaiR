#' OpenAI Client Class
#'
#' Main client class for interacting with OpenAI API.
#' Compatible with Python OpenAI SDK interface.
#'
#' @importFrom R6 R6Class
#' @export
OpenAI <- R6Class(
  "OpenAI",
  public = list(
    # Field: api_key OpenAI API key
    api_key = NULL,

    # Field: base_url Base URL for API requests
    base_url = NULL,

    # Field: organization Organization ID (optional)
    organization = NULL,

    # Field: project Project ID (optional)
    project = NULL,

    # Field: timeout Request timeout in seconds
    timeout = NULL,

    # Field: max_retries Maximum number of retries
    max_retries = NULL,

    # Field: chat Chat completions client
    chat = NULL,

    # Field: embeddings Embeddings client
    embeddings = NULL,

    # Field: images Images client
    images = NULL,

    # Field: audio Audio client
    audio = NULL,

    # Field: models Models client
    models = NULL,

    # Field: fine_tuning Fine-tuning client
    fine_tuning = NULL,

    # Field: files Files client
    files = NULL,

    # Field: moderations Moderations client
    moderations = NULL,

    # Field: completions Completions client (legacy)
    completions = NULL,

    # Field: batch Batch client
    batch = NULL,

    # Field: uploads Uploads client
    uploads = NULL,

    # Field: assistants Assistants client (beta)
    assistants = NULL,

    # Field: threads Threads client (beta)
    threads = NULL,

    # Field: vector_stores Vector stores client (beta)
    vector_stores = NULL,

    # Field: responses Responses client
    responses = NULL,

    # @description
    # Create and initialize an OpenAI API client. This is the main entry point
    # for all API interactions. All sub-clients (chat, embeddings, images, etc.)
    # are initialized automatically.
    #
    # @param api_key Character. Your OpenAI API key (starts with "sk-").
    #   If NULL, reads from the OPENAI_API_KEY environment variable.
    #   \strong{Recommended}: store key in ~/.Renviron as
    #   OPENAI_API_KEY=sk-... rather than hardcoding in scripts.
    #   Default: NULL.
    #
    # @param base_url Character. Base URL for all API requests.
    #   Change this to use OpenAI-compatible third-party APIs
    #   (e.g. ModelScope, Azure OpenAI, local LLM servers).
    #   Default: "https://api.openai.com/v1".
    #
    # @param organization Character. OpenAI Organization ID (format: "org-xxx").
    #   If NULL, reads from OPENAI_ORG_ID env var.
    #   Only needed if your account belongs to multiple organizations.
    #   Default: NULL.
    #
    # @param project Character. OpenAI Project ID (format: "proj-xxx").
    #   If NULL, reads from OPENAI_PROJECT_ID env var.
    #   Default: NULL.
    #
    # @param timeout Numeric. HTTP request timeout in seconds.
    #   Increase for long-running requests (large outputs, slow networks).
    #   Default: 600.
    #
    # @param max_retries Integer. Maximum number of automatic retries on
    #   transient errors (HTTP 408, 429, 500, 502, 503, 504).
    #   Uses exponential backoff between retries. Set to 0 to disable.
    #   Default: 2.
    #
    # @return An OpenAI R6 object with the following sub-client fields:
    #   \describe{
    #     \item{$chat}{ChatClient — Chat Completions API}
    #     \item{$embeddings}{EmbeddingsClient — Text embedding vectors}
    #     \item{$images}{ImagesClient — DALL-E image generation}
    #     \item{$audio}{AudioClient — Whisper transcription / TTS}
    #     \item{$models}{ModelsClient — List and manage models}
    #     \item{$fine_tuning}{FineTuningClient — Fine-tune jobs}
    #     \item{$files}{FilesClient — Upload and manage files}
    #     \item{$moderations}{ModerationsClient — Content safety}
    #     \item{$completions}{CompletionsClient — Legacy text completions}
    #     \item{$responses}{ResponsesClient — New Responses API}
    #   }
    initialize = function(api_key = NULL, base_url = NULL,
                          organization = NULL, project = NULL,
                          timeout = 600, max_retries = 2) {
      self$api_key <- api_key %||% Sys.getenv("OPENAI_API_KEY")
      if (self$api_key == "") {
        OpenAIError("No API key provided. Set OPENAI_API_KEY environment variable or pass api_key parameter.")
      }

      self$base_url <- base_url %||% "https://api.openai.com/v1"
      self$organization <- organization %||% Sys.getenv("OPENAI_ORG_ID", unset = NA)
      if (is.na(self$organization)) self$organization <- NULL
      self$project <- project %||% Sys.getenv("OPENAI_PROJECT_ID", unset = NA)
      if (is.na(self$project)) self$project <- NULL
      self$timeout <- timeout
      self$max_retries <- max_retries

      # Initialize sub-clients
      self$chat <- ChatClient$new(self)
      self$embeddings <- EmbeddingsClient$new(self)
      self$images <- ImagesClient$new(self)
      self$audio <- AudioClient$new(self)
      self$models <- ModelsClient$new(self)
      self$fine_tuning <- FineTuningClient$new(self)
      # New API sub-clients
      self$files <- FilesClient$new(self)
      self$moderations <- ModerationsClient$new(self)
      self$completions <- CompletionsClient$new(self)
      self$batch <- BatchClient$new(self)
      self$uploads <- UploadsClient$new(self)
      # Beta API sub-clients
      self$assistants <- AssistantsClient$new(self)
      self$threads <- ThreadsClient$new(self)
      self$vector_stores <- VectorStoresClient$new(self)
      self$responses <- ResponsesClient$new(self)
    },

    # Build common headers for API requests
    #
    # @return Named list of headers
    # @keywords internal
    build_headers = function() {
      headers <- list(
        "Authorization" = paste("Bearer", self$api_key),
        "OpenAI-Beta" = "assistants=v2"
      )

      if (!is.null(self$organization)) {
        headers[["OpenAI-Organization"]] <- self$organization
      }

      if (!is.null(self$project)) {
        headers[["OpenAI-Project"]] <- self$project
      }

      headers
    },

    # Make HTTP request to OpenAI API
    #
    # @param method HTTP method (GET, POST, DELETE)
    # @param path API path (e.g., "/chat/completions")
    # @param body Request body (list). Optional.
    # @param query Query parameters (list). Optional.
    # @param stream Whether to stream response. Default: FALSE
    # @param callback Function to call for each stream chunk (optional)
    # @return Parsed JSON response or stream callback
    # @keywords internal
    request = function(method, path, body = NULL, query = NULL, stream = FALSE, callback = NULL) {
      url <- paste0(self$base_url, path)

      headers <- self$build_headers()
      headers[["Content-Type"]] <- "application/json"

      req <- httr2::request(url)
      req <- httr2::req_method(req, method)
      req <- do.call(httr2::req_headers, c(list(req), headers))
      req <- httr2::req_timeout(req, self$timeout)

      # Add retry with exponential backoff
      req <- httr2::req_retry(req,
        max_tries = self$max_retries + 1,
        is_transient = function(resp) {
          httr2::resp_status(resp) %in% c(408, 429, 500, 502, 503, 504)
        }
      )

      if (!is.null(query)) {
        req <- httr2::req_url_query(req, !!!query)
      }

      if (!is.null(body)) {
        req <- httr2::req_body_json(req, body)
      }

      tryCatch(
        {
          if (stream) {
            # Handle streaming response with callback
            handle_stream_response(req, callback = callback)
          } else {
            resp <- httr2::req_perform(req)
            handle_response(resp)
          }
        },
        error = function(e) {
          if (inherits(e, "openai_error")) {
            stop(e)
          }
          OpenAIConnectionError(
            sprintf("Failed to connect to OpenAI API: %s", e$message),
            parent = e
          )
        }
      )
    },

    # Make multipart form data request to OpenAI API
    #
    # @param method HTTP method
    # @param path API path
    # @param ... Named arguments for multipart form data
    # @return Parsed JSON response
    # @keywords internal
    request_multipart = function(method, path, ...) {
      url <- paste0(self$base_url, path)

      headers <- self$build_headers()
      # Don't set Content-Type for multipart - httr2 sets it automatically

      req <- httr2::request(url)
      req <- httr2::req_method(req, method)
      req <- do.call(httr2::req_headers, c(list(req), headers))
      req <- httr2::req_timeout(req, self$timeout)
      req <- httr2::req_retry(req,
        max_tries = self$max_retries + 1,
        is_transient = function(resp) {
          httr2::resp_status(resp) %in% c(408, 429, 500, 502, 503, 504)
        }
      )

      # Add all multipart fields in one call
      req <- httr2::req_body_multipart(req, ...)

      tryCatch(
        {
          resp <- httr2::req_perform(req)
          handle_response(resp)
        },
        error = function(e) {
          if (inherits(e, "openai_error")) {
            stop(e)
          }
          OpenAIConnectionError(
            sprintf("Failed to connect to OpenAI API: %s", e$message),
            parent = e
          )
        }
      )
    },

    # Make raw (binary) request to OpenAI API
    #
    # @param method HTTP method
    # @param path API path
    # @param body Request body
    # @return Raw response body
    # @keywords internal
    request_raw = function(method, path, body = NULL) {
      url <- paste0(self$base_url, path)

      headers <- self$build_headers()
      headers[["Content-Type"]] <- "application/json"

      req <- httr2::request(url)
      req <- httr2::req_method(req, method)
      req <- do.call(httr2::req_headers, c(list(req), headers))
      req <- httr2::req_timeout(req, self$timeout)
      req <- httr2::req_retry(req,
        max_tries = self$max_retries + 1,
        is_transient = function(resp) {
          httr2::resp_status(resp) %in% c(408, 429, 500, 502, 503, 504)
        }
      )

      if (!is.null(body)) {
        req <- httr2::req_body_json(req, body)
      }

      tryCatch(
        {
          resp <- httr2::req_perform(req)

          status_code <- httr2::resp_status(resp)
          if (status_code >= 400) {
            handle_response(resp)
          }

          httr2::resp_body_raw(resp)
        },
        error = function(e) {
          if (inherits(e, "openai_error")) {
            stop(e)
          }
          OpenAIConnectionError(
            sprintf("Failed to connect to OpenAI API: %s", e$message),
            parent = e
          )
        }
      )
    }
  )
)
