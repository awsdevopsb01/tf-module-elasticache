resource "aws_security_group" "main" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "elasticache"
    from_port        = var.port_no
    to_port          = var.port_no
    protocol         = "tcp"
    cidr_blocks      = var.allow_db_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {Name="${var.env}-sg" })
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name}-${var.env}-dsng"
  subnet_ids = var.subnets

  tags = merge(var.tags, {Name="${var.env}-sbg" })
}

resource "aws_elasticache_parameter_group" "main" {
  name = "${var.name}-${var.env}-dbpg"
  family = "redis6.x"
  tags = merge(var.tags, {Name="${var.name}-${var.env}-ec-rpg" })
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.name}-${var.env}-elasticache-rpg"
  description                = "${var.name}-${var.env}-elasticache"
  node_type                  = var.node_type
  port                       = var.port_no
  parameter_group_name       = aws_elasticache_parameter_group.main.name
  security_group_ids         = [aws_security_group.main.id]
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  automatic_failover_enabled = true
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  at_rest_encryption_enabled = true
  kms_key_id                 = var.kms_arn
  engine                     = "redis"
  engine_version             = var.engine_version
  tags = merge(var.tags, {Name="${var.name}-${var.env}-ec-rpg" })
}