data "aws_vpc" "default" {
  default = true
}

# module "master-sg" {
#   source = "./modules/sg"
#   name = "master-sg"
#   description = "enable ssh and port 8080"
#   vpc-id = data.aws_vpc.default.id
#   enable_ingress_rule_1 = true
#   from-port = 22
#   to-port = 22

#   enable_ingress_rule_2 = true
#   from-port2 = 8080
#   to-port2 = 8080
# }

# module "jenkins-master" {
#   source = "./modules/ec2"
#   sg-id = [ module.master-sg.id ]
#   key-name = "3am"
#   user-data = file("${path.module}/script.sh")
#   name = "jenkins-master"
# }


# module "jenkins-slave" {
#   source = "./modules/ec2"
#   sg-id = [ module.slave-sg.id ]
#   name = "jenkins-slave"
#   key-name = "jenkins_slave_key"
# }

resource "aws_instance" "instance" {
  ami           = "ami-0da424eb883458071"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.slave-sg.id]
  
  key_name = "connection"
  connection {
    host        = aws_instance.instance.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_key_path)
  }

  tags = {
    Name = "todo-app"
  }

  }



module "slave-sg" {
  source = "./modules/sg"
  name = "slave-sg"
  description = "enable ssh and port 8080"
  vpc-id = data.aws_vpc.default.id
  enable_ingress_rule_1 = true
  from-port = 22
  to-port = 22

  enable_ingress_rule_2 = true
  from-port2 = 3000
  to-port2 = 3000
}

output "instance_public_ip" {
  value = aws_instance.instance.public_ip
}

resource "local_file" "public_ip" {
  content  = aws_instance.instance.public_ip
  filename = "${path.module}/ec2_public_ip.txt"
}