# Test Audio

test_that("Audio client initializes", {
  client <- OpenAI$new(api_key = "test-key")
  expect_s3_class(client$audio, "AudioClient")
  expect_s3_class(client$audio$transcriptions, "AudioTranscriptionsClient")
  expect_s3_class(client$audio$translations, "AudioTranslationsClient")
  expect_s3_class(client$audio$speech, "SpeechClient")
})

test_that("create_transcription function exists", {
  expect_true(exists("create_transcription"))
})

test_that("create_translation function exists", {
  expect_true(exists("create_translation"))
})

test_that("create_speech function exists", {
  expect_true(exists("create_speech"))
})

test_that("Speech create accepts required parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$audio$speech$create(
      input = "Hello world",
      model = "tts-1",
      voice = "alloy"
    ),
    NA
  )
})

test_that("Speech create accepts optional parameters", {
  client <- OpenAI$new(api_key = "test-key")
  
  expect_error(
    client$audio$speech$create(
      input = "Test speech",
      model = "tts-1-hd",
      voice = "nova",
      response_format = "mp3",
      speed = 1.0
    ),
    NA
  )
})
