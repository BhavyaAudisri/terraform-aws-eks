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