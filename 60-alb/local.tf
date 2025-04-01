locals {
  public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  alb_ingress_sg_id      = data.aws_ssm_parameter.alb_ingress_sg_id.value
  alb_ingress_certificate_arn = data.aws_ssm_parameter.alb_ingress_certificate_arn.value
}