# Test Moderations API

test_that("Moderations client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$moderations, "ModerationsClient")
})

test_that("Moderations create accepts parameters", {
  skip_on_cran()
  skip_if(Sys.getenv("OPENAI_API_KEY") == "" || Sys.getenv("OPENAI_API_KEY") == "test-key", "No valid API key")
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$moderations$create(input = "Test text"),
    NA
  )
})

test_that("create_moderation convenience function exists", {
  expect_true(exists("create_moderation"))
})
