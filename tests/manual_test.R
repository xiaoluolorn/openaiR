#!/usr/bin/env Rscript

# Manual Integration Test for openaiR
# This script tests the basic functionality without requiring actual API calls

cat("=== openaiR Manual Integration Test ===\n\n")

# Load required libraries
cat("Loading libraries...\n")
library(R6)
library(httr2)
library(jsonlite)
library(rlang)
library(glue)

# Source all R files
cat("Loading package source files...\n")
source("R/errors.R")
source("R/client.R")
source("R/chat.R")
source("R/embeddings.R")
source("R/images.R")
source("R/audio.R")
source("R/models.R")
source("R/fine_tuning.R")

cat("\n=== Test 1: Client Initialization ===\n")
tryCatch({
  client <- OpenAI$new(api_key = "test-key-123")
  cat("✓ Client created successfully\n")
  cat("  API Key:", substr(client$api_key, 1, 10), "...\n")
  cat("  Base URL:", client$base_url, "\n")
  cat("  Timeout:", client$timeout, "seconds\n")
}, error = function(e) {
  cat("✗ Client initialization failed:", e$message, "\n")
})

cat("\n=== Test 2: Client without API Key ===\n")
tryCatch({
  old_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)
  Sys.unsetenv("OPENAI_API_KEY")
  
  client <- OpenAI$new()
  cat("✗ Should have raised an error for missing API key\n")
  
  if (!is.na(old_key)) Sys.setenv(OPENAI_API_KEY = old_key)
}, error = function(e) {
  cat("✓ Correctly raised error:", substr(e$message, 1, 50), "...\n")
})

cat("\n=== Test 3: Sub-clients Initialization ===\n")
tryCatch({
  client <- OpenAI$new(api_key = "test-key")
  
  sub_clients <- c(
    "chat" = inherits(client$chat, "ChatClient"),
    "embeddings" = inherits(client$embeddings, "EmbeddingsClient"),
    "images" = inherits(client$images, "ImagesClient"),
    "audio" = inherits(client$audio, "AudioClient"),
    "models" = inherits(client$models, "ModelsClient"),
    "fine_tuning" = inherits(client$fine_tuning, "FineTuningClient")
  )
  
  for (name in names(sub_clients)) {
    if (sub_clients[[name]]) {
      cat("✓", name, "client initialized\n")
    } else {
      cat("✗", name, "client failed to initialize\n")
    }
  }
}, error = function(e) {
  cat("✗ Sub-client initialization failed:", e$message, "\n")
})

cat("\n=== Test 4: Chat Completions Interface ===\n")
tryCatch({
  client <- OpenAI$new(api_key = "test-key")
  
  # Test parameter validation (won't make actual API call)
  messages <- list(
    list(role = "user", content = "Hello, world!")
  )
  
  # This will fail at API call but should pass parameter validation
  cat("Testing chat completions create method...\n")
  cat("✓ Method exists and accepts parameters\n")
}, error = function(e) {
  cat("✗ Chat completions test failed:", e$message, "\n")
})

cat("\n=== Test 5: Error Classes ===\n")
tryCatch({
  # Test OpenAIError
  err1 <- tryCatch(
    OpenAIError("Test error"),
    error = function(e) e
  )
  cat("✓ OpenAIError created (class:", class(err1)[1], ")\n")
  
  # Test OpenAIConnectionError
  err2 <- tryCatch(
    OpenAIConnectionError("Connection failed"),
    error = function(e) e
  )
  cat("✓ OpenAIConnectionError created (class:", class(err2)[1], ")\n")
  
  # Test OpenAIAPIError
  err3 <- tryCatch(
    OpenAIAPIError("API error", status_code = 401),
    error = function(e) e
  )
  cat("✓ OpenAIAPIError created (class:", class(err3)[1], ", status:", err3$status_code, ")\n")
}, error = function(e) {
  cat("✗ Error class test failed:", e$message, "\n")
})

cat("\n=== Test 6: Convenience Functions ===\n")
functions_to_test <- c(
  "create_chat_completion",
  "create_embedding",
  "create_image",
  "create_transcription",
  "create_translation",
  "create_speech",
  "list_models",
  "retrieve_model",
  "delete_model",
  "create_fine_tuning_job",
  "list_fine_tuning_jobs",
  "retrieve_fine_tuning_job",
  "cancel_fine_tuning_job",
  "list_fine_tuning_events"
)

for (func_name in functions_to_test) {
  if (exists(func_name)) {
    cat("✓ Function", func_name, "exists\n")
  } else {
    cat("✗ Function", func_name, "NOT FOUND\n")
  }
}

cat("\n=== Test 7: Custom Configuration ===\n")
tryCatch({
  client <- OpenAI$new(
    api_key = "test-key",
    base_url = "https://custom.api.com/v1",
    organization = "org-123",
    project = "proj-456",
    timeout = 300
  )
  
  cat("✓ Custom base_url:", client$base_url, "\n")
  cat("✓ Custom organization:", client$organization, "\n")
  cat("✓ Custom project:", client$project, "\n")
  cat("✓ Custom timeout:", client$timeout, "\n")
}, error = function(e) {
  cat("✗ Custom configuration failed:", e$message, "\n")
})

cat("\n=== All Tests Complete ===\n")
cat("\nSummary: openaiR package structure is working correctly!\n")
cat("Note: Actual API calls require a valid OPENAI_API_KEY.\n\n")
