module "mysql_sg" {
    source = "git::https://github.com/BhavyaAudisri/terraform-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    sg_description = "Created for MySQL or database instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "bastion_sg" {
    source = "git::https://github.com/BhavyaAudisri/terraform-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    sg_description = "Created for bastion instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}


resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}


#Accepting traffic from frontend to app-alb
resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.backend_sg.sg_id
}

resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

# APP ALB accepting traffic from bastion host
resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id      = module.bastion_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}


resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

module "alb_ingress_sg" {
    source = "git::https://github.com/BhavyaAudisri/terraform-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "ingress-alb"
    sg_description = "Created for ingress ALB in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "eks_control_plane_sg" {
    source = "git::https://github.com/BhavyaAudisri/terraform-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "eks-control-plane"
    sg_description = "Created for eks control plane in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}

module "eks_node_sg" {
    source = "git::https://github.com/BhavyaAudisri/terraform-securitygroup.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "eks-node"
    sg_description = "Created for eks node in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
}
# ACCEPTING TRAFFIC FROM NODE TO EKS CONTROL PLANE
resource "aws_security_group_rule" "eks_control_plane_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = module.eks_node_sg.sg_id
  security_group_id = module.eks_control_plane_sg.sg_id
}
# ACCEPTING TRAFFIC FROM CONTROL PLANE TO NODE
resource "aws_security_group_rule" "eks_node_eks_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = module.eks_control_plane_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}
# ACCEPTING TRAFFIC FROM INGRESS TO NODE
resource "aws_security_group_rule" "node_alb_ingress" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  source_security_group_id       = module.alb_ingress_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}
# ACCEPTING TRAFFIC FROM VPC TO NODE
resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"] # our private IP address range
  security_group_id = module.eks_node_sg.sg_id
}

# ACCEPTING TRAFFIC FROM BASTION TO NODE
resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

#accepting traffic from bastion to ingress alb
resource "aws_security_group_rule" "alb_ingress_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.alb_ingress_sg.sg_id
}

resource "aws_security_group_rule" "alb_ingress_bastion_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.alb_ingress_sg.sg_id
}

resource "aws_security_group_rule" "alb_ingress_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.alb_ingress_sg.sg_id
}

# JDOPS-32, Bastion host should be accessed from office n/w

# ACCEPTING TRAFFIC FROM EKS NODE TO MYSQL
resource "aws_security_group_rule" "mysql_eks_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.eks_node_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}