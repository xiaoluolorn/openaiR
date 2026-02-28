# Test OpenAI Client Initialization

test_that("OpenAI client initializes with API key", {
  # Test with explicit API key
  client <- OpenAI$new(api_key = "test-key-123")
  expect_equal(client$api_key, "test-key-123")
  expect_equal(client$base_url, "https://api.openai.com/v1")
  expect_equal(client$timeout, 600)
})

test_that("OpenAI client requires API key", {
  # Temporarily unset environment variable
  old_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)
  Sys.unsetenv("OPENAI_API_KEY")
  
  on.exit({
    if (!is.na(old_key)) {
      Sys.setenv(OPENAI_API_KEY = old_key)
    }
  })
  
  expect_error(OpenAI$new(), "No API key provided")
})

test_that("OpenAI client accepts custom base URL", {
  client <- OpenAI$new(api_key = "test-key", base_url = "https://custom.api.com/v1")
  expect_equal(client$base_url, "https://custom.api.com/v1")
})

test_that("OpenAI client initializes sub-clients", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$chat, "ChatClient")
  expect_s3_class(client$embeddings, "EmbeddingsClient")
  expect_s3_class(client$images, "ImagesClient")
  expect_s3_class(client$audio, "AudioClient")
  expect_s3_class(client$models, "ModelsClient")
  expect_s3_class(client$fine_tuning, "FineTuningClient")
})

test_that("OpenAI client accepts organization and project", {
  client <- OpenAI$new(
    api_key = "test-key",
    organization = "org-123",
    project = "proj-456"
  )
  expect_equal(client$organization, "org-123")
  expect_equal(client$project, "proj-456")
})
