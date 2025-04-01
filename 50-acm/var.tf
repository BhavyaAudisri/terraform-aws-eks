variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = "true"
  }
}
variable "zone_id" {
    default = "Z0013005O0I1SBAMCWCB"
}
variable "domain_name" {
    default = "somisettibhavya.life"
}