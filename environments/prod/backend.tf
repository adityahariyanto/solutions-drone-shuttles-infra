terraform {
  backend "gcs" {
    bucket = "drone-shuttles-dev-tfstate"
    prefix = "env/prod"
  }
}