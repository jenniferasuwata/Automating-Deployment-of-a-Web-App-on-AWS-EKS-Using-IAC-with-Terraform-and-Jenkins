terraform {
    backend "s3" {
        bucket = "jenkinsbucketapp"
        key    = "eks/terraform.tfstate"
        region = "eu-west-1"
    }
}