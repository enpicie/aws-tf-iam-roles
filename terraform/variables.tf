variable "github_secret_visibility" {
  description = "Visibility of GitHub Actions organization secrets. One of: all, private, selected."
  type        = string
  default     = "all"

  validation {
    condition     = contains(["all", "private", "selected"], var.github_secret_visibility)
    error_message = "github_secret_visibility must be one of: all, private, selected."
  }
}
