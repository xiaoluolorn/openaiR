# Test Models

test_that("Models client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$models, "ModelsClient")
})

test_that("Models list method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$models$list))
})

test_that("Models retrieve method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$models$retrieve))
})

test_that("Models delete method exists", {
  client <- OpenAI$new(api_key = "test-key")
  expect_true(is.function(client$models$delete))
})

test_that("list_models convenience function works", {
  expect_error(
    list_models(),
    regexp = "No API key provided|Failed to connect"
  )
})

test_that("retrieve_model convenience function works", {
  expect_error(
    retrieve_model("gpt-3.5-turbo"),
    regexp = "No API key provided|Failed to connect"
  )
})

test_that("delete_model convenience function works", {
  expect_error(
    delete_model("ft:gpt-3.5-turbo:test"),
    regexp = "No API key provided|Failed to connect"
  )
})
