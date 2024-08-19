variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "sub1_cidr" {
    description = "Subnet 1 CIDR block"
    default = "10.0.0.0/24"
}

variable "sub2_cidr" {
    description = "Subnet 2 CIDR block"
    default = "10.0.1.0/24"
}