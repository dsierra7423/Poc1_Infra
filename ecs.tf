resource "aws_ecs_cluster" "main" {
  name = "poc-cluster"
}

###################################################################################
#############     FRONT END
###################################################################################
resource "aws_ecs_service" "front-end" {
  name            = "front-end-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.front-end.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.front-end.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lb-front-app.id
    container_name   = "front-end"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.lb-external-front]
}

resource "aws_security_group" "front-end" {
  name        = "example-task-security-group"
  vpc_id      = aws_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb-external.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "front-end" {
  family                   = "front-end-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = "${file("task-definitions/front.json")}"
}
