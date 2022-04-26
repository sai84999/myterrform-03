############################ variables #########################################

variable "myaccess_key" {}
variable "mysecret_key" {}

################### provides  ########################################
provider "aws" {
  access_key = "${var.myaccess_key}"
  secret_key = "${var.mysecret_key}"
  region = "ap-south-1"
}

############################## resources  #######################################
resource "aws_instance" "myec2server" {
  ami = "ami-0851b76e8b1bce90b"
  instance_type = "t2.micro"
  key_name = "dockerkey"

  tags = {
    "Name" = "myec2server"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("dockerkey.pem")}"
    host = aws_instance.myec2server.public_ip
    agent = false
    timeout = "300s"

  }


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
    ]
  }
}

############################## output #######################################

output "myec2serverpublicip" { value = aws_instance.myec2server.public_ip}