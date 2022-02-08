variable "password" {
   description = "password"
   type = string
   }

variable region1 {
  default = "us-east-1"
}
variable region2 {
  default = "us-west-1"
}

variable transit_vpc1_name {
  default = "us-east1-transitvpc"
}

variable transit_vpc2_name {
  default = "us-west1-transitvpc"
}

variable account_name {
  default = "flottAWS"
}

variable transitname1 {
  default = "us-east1-transit-gw"
}

variable transitname2 {
  default = "us-west1-transit-gw"
}

variable transit_gw_size {
  default = "c5n.xlarge"
}

variable cidr1 {
   default = "10.50.50.0/23"
}

variable cidr2 {
   default = "10.50.52.0/23"
}


variable "az1" {
  description = "Concatenates with region to form az names. e.g. eu-central-1a. Only used for insane mode"
  type        = string
  default     = "a"
}

variable "az2" {
  description = "Concatenates with region to form az names. e.g. eu-central-1b. Only used for insane mode"
  type        = string
  default     = "b"
}

locals {
  cidrbits                = tonumber(split("/", var.cidr1)[1])
  cidrbits2               = tonumber(split("/", var.cidr2)[1])
  newbits                 = 26 - local.cidrbits
  newbits2                = 26 - local.cidrbits2
  netnum                  = pow(2, local.newbits)
  netnum2                 = pow(2, local.newbits2)
  subnet                  = cidrsubnet(var.cidr1, local.newbits, local.netnum - 2)
  ha_subnet               = cidrsubnet(var.cidr1, local.newbits, local.netnum - 1)
  subnet2                 = cidrsubnet(var.cidr2, local.newbits2, local.netnum2 - 2)
  ha_subnet2              = cidrsubnet(var.cidr2, local.newbits2, local.netnum2 - 1)
  us-east-az1             = "${var.region1}${var.az1}"
  us-east-az2             = "${var.region1}${var.az2}"
  us-west-az1             = "${var.region2}${var.az1}"
  us-west-az2             = "${var.region2}${var.az2}"
  insane_mode_az_e        = local.us-east-az1
  ha_insane_mode_az_e     = local.us-east-az2
  insane_mode_az_w        = local.us-west-az1
  ha_insane_mode_az_w     = local.us-west-az2
}
