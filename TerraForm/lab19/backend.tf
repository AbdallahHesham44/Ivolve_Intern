terraform {
  backend "s3" {
    bucket         = "aha-my-backend-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
