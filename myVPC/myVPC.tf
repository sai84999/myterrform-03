########### variables

variable "myaccess_key" { default = "AKIAURAI3WPSRVIOLV7S"}
variable "mysecret_key" { default = "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"}




########### providers
provider "aws" {
access_key = "${var.myaccess_key}"
secret_key = "${var.mysecret_key}"
region = "ap-south-1"

}

########### resources
resource "aws_vpc" "myVPC" {
  cidr_block = "192.168.0.0/22"
  tags = {
    "Name" = "myvpc"  
  }

}


resource "aws_subnet" "myPublicSubnet" {
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-south-1a"
    vpc_id = aws_vpc.myVPC.id

}

resource "aws_route_table" "myPubicRoutingtable" {
    vpc_id = aws_vpc.myVPC.id

}

resource "aws_route_table_association" "mypublicRTassociation" {
    subnet_id = aws_subnet.myPublicSubnet.id
    route_table_id = aws_route_table.myPubicRoutingtable.id
  
}


resource "aws_egress_only_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
}


resource "aws_route" "myroute" {
  route_table_id              = aws_route_table.myPubicRoutingtable.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.myIGW.id
}

resource "aws_instance" "myinstance" {
    ami = "ami-0851b76e8b1bce90b"
    instance_type = "t2.micro"
    key_name = "dockerkey"
    subnet_id = aws_subnet.myPublicSubnet.id
}




########### output

output "myvpcid" { value = aws_vpc.myVPC.id}
output "myPublicSubnetid" { value = aws_subnet.myPublicSubnet.id}
output "myPublicRoutingtableid" { value= aws_route_table.myPubicRoutingtable.id}
output "myIGWid" { value = aws_egress_only_internet_gateway.myIGW.id}
output "myinstanceid" { value = aws_instance.myinstance.id}