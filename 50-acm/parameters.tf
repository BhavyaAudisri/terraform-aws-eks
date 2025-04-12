resource "aws_ssm_parameter" "alb_ingress_certificate_arn" {
  name  = "/${var.project_name}/${var.environment}/alb_ingress_certificate_arn"
  type  = "String"
  value = aws_acm_certificate.expense.arn
  overwrite = true
}