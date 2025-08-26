# Get the AWS account ID of the current caller
data "aws_caller_identity" "current" {}

# Get authorization token for Amazon ECR registry access

data "aws_ecr_authorization_token" "token" {}


provider "docker" {
  registry_auth {

    # ECR registry address using AWS account ID and region
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password

  }
}

# Create ECR Repository to store container images
resource "aws_ecr_repository" "ecr_repo" {
  # Repository name from variable
  name = var.repository_name
  # Allow image tags to be overwritten
  image_tag_mutability = "MUTABLE"
  force_delete         = true

}

# Build Docker image from local Dockerfile
resource "docker_image" "image" {
  # Image name using ECR repository URL with latest tag
  name = "${aws_ecr_repository.ecr_repo.repository_url}:latest"
  build {
    # amazonq-ignore-next-line
    context    = "${path.module}./"
    dockerfile = "Dockerfile"

  }
}

# Push built Docker image to ECR repository
resource "docker_registry_image" "image" {
  # Use the built image name
  name = docker_image.image.name
  # Ensure repository exists and image is built before pushing
  depends_on = [aws_ecr_repository.ecr_repo, docker_image.image]

}

