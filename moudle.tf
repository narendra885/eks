provider "aws" {
  region = "${var.AWS_REGION}"
  #shared_credentials_file="/Users/AppsTekO20/.aws/credentials"
   access_key = ""
   secret_key = ""
}


module "vpc" {
  source = "./vpc"
  cluster-name = "${var.cluster-name}"
  AWS_REGION = "${var.AWS_REGION}"
  
}
module "eks" {
  source = "./eks"
  security_group_ids = "${module.eks.sgid}"
  subnet_ids = "${module.vpc.subnetid}"
  vpc_id = "${module.vpc.vpcid}"
  cluster-name = "${var.cluster-name}"
  instancetype = "${var.instancetype}"
  keyname = "${var.keyname}"
  
}

module "key" {
  source = "./key"
  keyname ="${var.keyname}"
}


module "kub" {
  source = "./kub"
  endpoint = "${module.eks.eksendpoint}"
  cer = "${module.eks.clustercer}"
  cluster-name = "${module.eks.cluster-name}"
  #url = "${module.ecr.url}"
  POD_REPLICAS = "${var.POD_REPLICAS}"
}


module "ecr" {
  source = "./ecr"
  
}
