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
    default = "Z069418416OLTG3EK07HC"
}

variable "domain_name" {
    default = "somisettibhavya.life"
}