output "db_sg_id" {
  value = module.mysql_sg.sg_id
}
output "vpc_id" {
  value     = data.aws_ssm_parameter.vpc_id
  sensitive = true
}