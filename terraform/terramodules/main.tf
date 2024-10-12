data "aws_vpc" "default" {
  default = true
}

module "master-sg" {
  source = "./modules/sg"
  name = "master-sg"
  description = "enable ssh and port 8080"
  vpc-id = data.aws_vpc.default.id
  enable_ingress_rule_1 = true
  from-port = 22
  to-port = 22

  enable_ingress_rule_2 = true
  from-port2 = 8080
  to-port2 = 8080
}

module "jenkins-master" {
  source = "./modules/ec2"
  sg-id = [ module.master-sg.id ]
  key-name = "connection"
  user-data = file("${path.module}/script.sh")
  name = "Jenkins-master"
}
