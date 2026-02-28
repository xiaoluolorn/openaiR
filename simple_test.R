# Simple test for openaiR package

cat("Loading R6...\n")
library(R6)

cat("Sourcing all package files...\n")
source("R/errors.R")
source("R/client.R")
source("R/chat.R")
source("R/embeddings.R")
source("R/images.R")
source("R/audio.R")
source("R/models.R")
source("R/fine_tuning.R")

cat("Creating client...\n")
client <- OpenAI$new(api_key = "sk-test123")

cat("✓ Client created!\n")
cat("  Base URL:", client$base_url, "\n")
cat("  API Key:", substr(client$api_key, 1, 10), "...\n")
cat("  Chat client:", class(client$chat)[1], "\n")
cat("  Embeddings client:", class(client$embeddings)[1], "\n")
cat("  Images client:", class(client$images)[1], "\n")
cat("  Audio client:", class(client$audio)[1], "\n")
cat("  Models client:", class(client$models)[1], "\n")
cat("  Fine-tuning client:", class(client$fine_tuning)[1], "\n")

cat("\n✓ All basic tests passed!\n")
