
# CodeBuild project
resource "aws_codebuild_project" "rr_build" {
  name          = "ritual-roast-build"
  description   = "Build project for ritual roast website"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = 60

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      value = var.repository_name
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }

    environment_variable {
      name  = "EXECUTION_ROLE_ARN"
      value = aws_iam_role.ecs_task_execution_role.arn
    }
    environment_variable {
      name  = "TASK_ROLE_ARN"
      value = aws_iam_role.ecs_task_role.arn
    }

    environment_variable {
      name  = "TASK_CPU"
      value = var.task_cpu
    }

    environment_variable {
      name  = "TASK_MEMORY"
      value = var.task_memory
    }

    environment_variable {
      name  = "TASK_FAMILY"
      value = var.family
    }

    environment_variable {
      name  = "LOG_GROUP_NAME"
      value = var.log_group_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
  depends_on = [aws_ecs_cluster.cluster, aws_ecs_service.ecs_service, aws_ecs_task_definition.task_definition]
}