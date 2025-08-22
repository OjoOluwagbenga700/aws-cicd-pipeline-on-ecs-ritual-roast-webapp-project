resource "aws_db_instance" "mysql" {
  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.storage
  db_name                = var.db_database
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids = [aws_security_group.private_db_tier_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags = {
    Name = "${var.identifier}-mysql"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = module.networking.private_subnets
  depends_on  = [module.networking]
}