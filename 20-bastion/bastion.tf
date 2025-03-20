resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.joindevops.id
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  instance_type          = var.instance_type
  subnet_id = local.public_subnet_id
    # 20GB is not enough
  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  user_data = file("userdata.sh")

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-bastion"
  }
  )
}