resource "aws_ssm_parameter" "alb_ingress_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/alb_ingress_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}
resource "aws_ssm_parameter" "alb_tg_frontend_arn" {
  name  = "/${var.project_name}/${var.environment}/alb_tg_frontend_arn"
  type  = "String"
  value = aws_lb_target_group.frontend.arn
}