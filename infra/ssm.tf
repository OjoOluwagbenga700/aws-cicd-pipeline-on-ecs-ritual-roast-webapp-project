
resource "aws_ssm_parameter" "db_username" {
  name  = "/app/db_username"
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/app/db_password"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_ssm_parameter" "db_server" {
  name       = "/app/db_host"
  type       = "String"
  value      = aws_db_instance.mysql.endpoint
  depends_on = [aws_db_instance.mysql]
}

resource "aws_ssm_parameter" "db_database" {
  name  = "/app/db_database"
  type  = "String"
  value = var.db_database
}
