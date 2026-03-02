# Test Fine-tuning

test_that("Fine-tuning client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$fine_tuning, "FineTuningClient")
  expect_s3_class(client$fine_tuning$jobs, "FineTuningJobsClient")
})

test_that("Fine-tuning jobs create accepts required parameters", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$fine_tuning$jobs$create(
      training_file = "file-abc123",
      model = "gpt-3.5-turbo"
    ),
    NA
  )
})

test_that("Fine-tuning jobs create accepts optional parameters", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$fine_tuning$jobs$create(
      training_file = "file-abc123",
      model = "gpt-3.5-turbo",
      hyperparameters = list(n_epochs = 3, batch_size = 4),
      suffix = "custom-model",
      validation_file = "file-xyz789",
      seed = 42
    ),
    NA
  )
})

test_that("Fine-tuning jobs list method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$fine_tuning$jobs$list))
})

test_that("Fine-tuning jobs retrieve method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$fine_tuning$jobs$retrieve))
})

test_that("Fine-tuning jobs cancel method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$fine_tuning$jobs$cancel))
})

test_that("Fine-tuning jobs list_events method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$fine_tuning$jobs$list_events))
})

test_that("Convenience functions exist", {
  expect_true(exists("create_fine_tuning_job"))
  expect_true(exists("list_fine_tuning_jobs"))
  expect_true(exists("retrieve_fine_tuning_job"))
  expect_true(exists("cancel_fine_tuning_job"))
  expect_true(exists("list_fine_tuning_events"))
})
