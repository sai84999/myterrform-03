#variables
variable "myregion" {
  default="ap-south-1"
}
variable "myaccesskey" {
    default = "AKIAURAI3WPSRVIOLV7S"
}
variable "mysecretkey" {
    default = "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"
    }




    #providers
    provider "aws" {
      region = "${var.myregion}"
      access_key = "${var.myaccesskey}"
      secret_key = "${var.mysecretkey}"
    }
    #resources
    resource "aws_instance" "myinstance" {
      ami = "ami-0851b76e8b1bce90b"
      key_name = "dockerkey"
      instance_type = "t2.micro"
    }


    # outputs

    output "myinstanceid" {
        value = aws_instance.myinstance.id
    }