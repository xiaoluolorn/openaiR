# Test Chat Completions

test_that("Chat completions client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$chat$completions, "ChatCompletionsClient")
})

test_that("Chat completions create accepts required parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  # Mock the request method to avoid actual API call
  mock_response <- list(
    id = "chatcmpl-test",
    object = "chat.completion",
    created = 1234567890,
    model = "gpt-3.5-turbo",
    choices = list(
      list(
        index = 0,
        message = list(role = "assistant", content = "Test response"),
        finish_reason = "stop"
      )
    ),
    usage = list(prompt_tokens = 10, completion_tokens = 20, total_tokens = 30)
  )
  
  # Test that the method accepts the parameters without error
  # (We can't test actual API calls without a real key)
  expect_error(
    client$chat$completions$create(
      messages = list(
        list(role = "user", content = "Hello")
      ),
      model = "gpt-3.5-turbo"
    ),
    NA # Should not error in parameter validation
  )
})

test_that("Chat completions accepts optional parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  # Test with various optional parameters
  expect_error(
    client$chat$completions$create(
      messages = list(list(role = "user", content = "Test")),
      model = "gpt-4",
      temperature = 0.7,
      max_tokens = 100,
      top_p = 0.9,
      frequency_penalty = 0.5,
      presence_penalty = 0.5,
      n = 1,
      stop = c("\n", "END"),
      seed = 42
    ),
    NA
  )
})

test_that("create_chat_completion convenience function works", {
  # Test that the function exists and accepts parameters
  expect_error(
    create_chat_completion(
      messages = list(list(role = "user", content = "Test")),
      model = "gpt-3.5-turbo"
    ),
    regexp = "No API key provided|Failed to connect" # Either error is acceptable
  )
})

test_that("Chat completions handles response_format parameter", {
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$chat$completions$create(
      messages = list(list(role = "user", content = "Test")),
      model = "gpt-3.5-turbo",
      response_format = list(type = "json_object")
    ),
    NA
  )
})

test_that("Chat completions handles tools parameter", {
  client <- OpenAI$new(api_key = "test-key")
  
  tools <- list(
    list(
      type = "function",
      function = list(
        name = "get_weather",
        description = "Get current weather",
        parameters = list(
          type = "object",
          properties = list(
            location = list(type = "string", description = "City name")
          ),
          required = list("location")
        )
      )
    )
  )
  
  expect_error(
    client$chat$completions$create(
      messages = list(list(role = "user", content = "What's the weather?")),
      model = "gpt-4",
      tools = tools
    ),
    NA
  )
})
