# Test Error Handling

test_that("OpenAIError is raised correctly", {
  expect_error(
    OpenAIError("Test error message"),
    class = "openai_error"
  )
})

test_that("OpenAIConnectionError is raised correctly", {
  expect_error(
    OpenAIConnectionError("Connection failed"),
    class = "openai_connection_error"
  )
})

test_that("OpenAIAPIError is raised correctly", {
  expect_error(
    OpenAIAPIError("API error", status_code = 401),
    class = "openai_api_error"
  )
})

test_that("OpenAIAPIError includes status code", {
  err <- tryCatch(
    OpenAIAPIError("Not found", status_code = 404),
    error = function(e) e
  )
  expect_equal(err$status_code, 404)
})

test_that("Error classes inherit from base OpenAIError", {
  conn_err <- tryCatch(
    OpenAIConnectionError("Connection failed"),
    error = function(e) e
  )
  expect_true(inherits(conn_err, "openai_error"))
  
  api_err <- tryCatch(
    OpenAIAPIError("API error"),
    error = function(e) e
  )
  expect_true(inherits(api_err, "openai_error"))
})
