resource "aws_ssm_parameter" "alb_ingress_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/alb_ingress_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
  overwrite = true
}