module "transit_firenet_us_east" {
  source  = "terraform-aviatrix-modules/aws-transit-firenet/aviatrix"
  version = "4.0.3"
  
  cidr = "10.50.50.0/23"
  region = "us-east-1"
  account = "flottAWS"
  firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  instance_size = "c5n.xlarge"
  insane_mode = true
  fw_amount = 0
  enable_segmentation = true
  local_as_number = "65005"
}

/* 
module "transit_firenet_us_west" {
  source  = "terraform-aviatrix-modules/aws-transit-firenet/aviatrix"
  version = "4.0.3"
  
  cidr = "10.50.52.0/23"
  region = "us-west-1"
  account = "flottAWS"
  firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  instance_size = "c5n.xlarge"
  insane_mode = true
  fw_amount = 0
  enable_segmentation = true
  local_as_number = "65006"
}
  
module "transit_firenet_central_us" {
  source  = "terraform-aviatrix-modules/azure-transit-firenet/aviatrix"
  version = "4.0.3"
  
  cidr = "10.50.54.0/23"
  region = "Central US"
  account = "Azure1"
  firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall Bundle 1"
  firewall_image_version = "9.1.0"
  instance_size = "Standard_D3_v2"
  insane_mode = true
  insane_instance_size = "Standard_D3_v2"
  
  enable_segmentation = true
  #deploy_firenet = false
  #fw_amount = 0
  local_as_number = "65007"
  
}
  
  
module "transit-peering" {
  source  = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version = "1.0.4"
  transit_gateways = [
    module.transit_firenet_us_east.transit_gateway.gw_name,
    module.transit_firenet_us_west.transit_gateway.gw_name
  ]
}

    
resource "aviatrix_transit_external_device_conn" "AVXtoDC" {
  vpc_id            = module.transit_firenet_us_east.transit_gateway.vpc_id
  connection_name   = "my_conn"
  gw_name           = module.transit_firenet_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_firenet_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = "345"
  remote_gateway_ip = "6.6.6.6"
}
*/

resource "aviatrix_aws_tgw_connect" "test_aws_tgw_connect" {
  tgw_name             = "NVATGW"
  connection_name      = "aws-tgw-connect"
  transport_vpc_id     = "vpc-0650d8b3dc4116c06"
  security_domain_name = "Default_Domain"
}

resource "aviatrix_aws_tgw_connect_peer" "test" {
  tgw_name              = "NVATGW"
  connection_name       = "aws-tgw-connect"
  connect_peer_name     = "connect-peer-test"
  connect_attachment_id = aviatrix_aws_tgw_connect.test_aws_tgw_connect.connect_attachment_id
  peer_as_number        = "65005"
  peer_gre_address      = "10.50.51.148"
  bgp_inside_cidrs      = ["169.254.6.0/29"]
  tgw_gre_address       = "10.19.18.5"
}

resource "aviatrix_transit_external_device_conn" "AVXtoTGW" {
  vpc_id            = module.transit_firenet_us_east.transit_gateway.vpc_id
  connection_name   = "my_conn"
  gw_name           = module.transit_firenet_us_east.transit_gateway.gw_name
  connection_type   = "bgp"
  bgp_local_as_num  = module.transit_firenet_us_east.transit_gateway.local_as_number
  bgp_remote_as_num = "64512"
  remote_gateway_ip = "10.19.18.5"
  tunnel_protocol   = "GRE"
  remote_tunnel_cidr     = "169.254.6.2/30,169.254.6.6/30"
  local_tunnel_cidr      = "169.254.6.1/30,169.254.6.5/30"

}
