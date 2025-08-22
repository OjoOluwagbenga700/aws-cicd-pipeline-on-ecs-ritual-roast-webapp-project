# Name of the ECS cluster
variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"

}

# Name of the ECS service
variable "service_name" {
  type        = string
  description = "UI ECS service name"

}


# Task definition family name
variable "family" {
  type        = string
  description = "Task family name"
}


# CPU units allocated to the ECS task
variable "task_cpu" {
  type        = number
  description = "CPU units for the task"

}

# Memory allocated to the ECS task
variable "task_memory" {
  type        = number
  description = "Memory units for the task"

}

# Name of the container
variable "container_name" {
  type        = string
  description = "Container name"
}

# Name of the ECR repository
variable "repository_name" {
  type        = string
  description = "ECR repository name"

}


# AWS region where resources will be created
variable "aws_region" {
  type        = string
  description = "AWS region"
}

# CloudWatch log group name for ECS tasks
variable "log_group_name" {
  type        = string
  description = "Log group name for the application"

}

# CIDR range for the VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

# Name tag for the VPC
variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

# Availability zones for VPC subnets
variable "azs" {
  type        = list(string)
  description = "Availability zones for the VPC"
}

# CIDR ranges for public subnets
variable "public_subnets" {
  type        = list(string)
  description = "Public subnets for the VPC"
}

# CIDR ranges for private subnets
variable "private_subnets" {
  type        = list(string)
  description = "Private subnets for the VPC"

}


variable "github_repo" {
  type        = string
  description = "GitHub repository for the source code (format: owner/repo)"
}

variable "github_branch" {
  type        = string
  description = "GitHub branch to use for the source code"
}

variable "codepipeline_bucket_name" {
  description = "Name of the S3 bucket for CodePipeline artifacts"
  type        = string
}


variable "private_subnet_names" {
  description = "Names of the private subnets"
  type        = list(string)
}

variable "public_subnet_names" {
  description = "Names of the public subnets"
  type        = list(string)

}

variable "project_name" {
  description = "Name of the project"
  type        = string
}


variable "db_username" {
  description = "Database username"
  type        = string
}
variable "db_password" {
  description = "Database password"
  type        = string
}

variable "db_database" {
  description = "Database name"
  type        = string
}

variable "identifier" {
  description = "Identifier for the database instance"
  type        = string

}
variable "storage" {
  description = "Storage configuration for the database"
  type        = string

}
variable "engine" {
  description = "Database engine to use"
  type        = string


}
variable "engine_version" {
  description = "Version of the database engine"
  type        = string
}
variable "instance_class" {
  description = "Instance class for the database"
  type        = string

}