files <- list.files("R", full.names = TRUE, pattern = "\\.R$")
for (f in files) {
  txt <- readLines(f, warn = FALSE)
  # Replace indented roxygen comments with regular comments
  # because roxygen2 gets confused when they are inside R6 class definitions
  has_indented_roxygen <- grepl("^\\s+#'", txt)
  if (any(has_indented_roxygen)) {
    txt[has_indented_roxygen] <- sub("^(\\s+)#'", "\\1#", txt[has_indented_roxygen])
    writeLines(txt, f)
    cat("Fixed indented roxygen in:", f, "\n")
  }
}
cat("Done\n")
