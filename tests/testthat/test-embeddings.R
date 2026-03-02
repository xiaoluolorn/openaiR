# Test Embeddings

test_that("Embeddings client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$embeddings, "EmbeddingsClient")
})

test_that("Embeddings create accepts required parameters", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$embeddings$create(
      input = "The quick brown fox",
      model = "text-embedding-ada-002"
    ),
    NA
  )
})

test_that("Embeddings accepts multiple inputs", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$embeddings$create(
      input = c("Text 1", "Text 2", "Text 3"),
      model = "text-embedding-ada-002"
    ),
    NA
  )
})

test_that("Embeddings accepts optional parameters", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$embeddings$create(
      input = "Test text",
      model = "text-embedding-3-small",
      encoding_format = "float",
      dimensions = 512,
      user = "user-123"
    ),
    NA
  )
})

test_that("create_embedding convenience function works", {
  expect_error(
    create_embedding(
      input = "Test text",
      model = "text-embedding-ada-002"
    ),
    regexp = "No API key provided|Failed to connect"
  )
})
