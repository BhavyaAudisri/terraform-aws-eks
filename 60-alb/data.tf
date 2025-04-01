data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}
data "aws_ssm_parameter" "alb_ingress_sg_id" {
  name = "/${var.project_name}/${var.environment}/alb_ingress_sg_id"
}
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public-subnet_ids"
}
data "aws_ssm_parameter" "alb_ingress_certificate_arn" {
  name = "/${var.project_name}/${var.environment}/alb_ingress_certificate_arn"
}
# data "aws_ssm_parameter" "alb_ingress_listener_arn" {
#   name = "/${var.project_name}/${var.environment}/alb_ingress_listener_arn"
# }