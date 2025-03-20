# output "azs_info" {
#     value = module.vpc.azs_info
# }
output "elastic_ip" {
  value = module.vpc.elastic_ip
}

output "pub_route_id" {
  value = module.vpc.pub_route_id
}
output "pri_route_id" {
  value = module.vpc.pri_route_id
}
output "db_route_id" {
  value = module.vpc.db_route_id
}
output "default_vpc_id" {
  value = module.vpc.default_vpc_id
}
output "default_vpc_cidr_block" {
  value = module.vpc.default_vpc_cidr_block
}
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
  }

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}
output "gw_id" {
  value = module.vpc.gw_id
}