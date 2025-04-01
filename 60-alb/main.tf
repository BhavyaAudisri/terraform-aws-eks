module "alb" {
  source   = "terraform-aws-modules/alb/aws"
  internal = false
  #expense-dev-web-alb
  name                  = "${var.project_name}-${var.environment}-alb_ingress"
  vpc_id                = data.aws_ssm_parameter.vpc_id.value
  subnets               = local.public_subnet_ids
  create_security_group = false
  security_groups       = [local.alb_ingress_sg_id]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-alb_ingress"
    }
  )
  enable_deletion_protection = false
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.alb_ingress_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from ingress ALB with HTTPS</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "alb_ingress" {
 zone_id = var.zone_id
 name = "expense-dev.${var.domain_name}"
 type = "A"
#these are ALB DNS name and zone details
 alias {
    name = module.alb.dns_name
    zone_id = module.alb.zone_id
    evaluate_target_health = false
        }
}

resource "aws_lb_target_group" "frontend" {
  name     = local.resource_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
  target_type = "ip"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    protocol = "HTTP"
    port = 8080
    path = "/"
    matcher = "200-299"
    interval = 10
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = data.aws_ssm_parameter.alb_ingress_certificate_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.domain_name}"]
    }
  }
}