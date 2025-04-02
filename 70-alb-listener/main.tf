resource "aws_lb_listener_rule" "frontend" {
  listener_arn = data.aws_ssm_parameter.alb_ingress_listener_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = local.alb_tg_frontend_arn.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.domain_name}"]
    }
  }
}