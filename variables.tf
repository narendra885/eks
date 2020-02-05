#
# Variables Configuration
#


variable "AWS_REGION" {
  
}



variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}
variable "instancetype" {
   default = ["t3.medium"]
  
}

variable "keyname" {
  default = "ekskey"
}

variable "POD_REPLICAS" {
  default = "0"
}