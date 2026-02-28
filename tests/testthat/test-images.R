# Test Images

test_that("Images client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$images, "ImagesClient")
})

test_that("Image create accepts required parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$images$create(
      prompt = "A cute baby sea otter",
      model = "dall-e-3"
    ),
    NA
  )
})

test_that("Image create accepts optional parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$images$create(
      prompt = "A beautiful sunset over mountains",
      model = "dall-e-3",
      n = 1,
      quality = "hd",
      response_format = "url",
      size = "1024x1024",
      style = "vivid",
      user = "user-123"
    ),
    NA
  )
})

test_that("create_image convenience function works", {
  expect_error(
    create_image(
      prompt = "A test image",
      model = "dall-e-3"
    ),
    regexp = "No API key provided|Failed to connect"
  )
})

test_that("Image edit function exists", {
  expect_true(exists("create_image_edit"))
})

test_that("Image variation function exists", {
  expect_true(exists("create_image_variation"))
})
