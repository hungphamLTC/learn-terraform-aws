data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "terraform-remote-state-40h2b"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}
