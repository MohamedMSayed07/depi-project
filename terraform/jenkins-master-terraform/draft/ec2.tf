# resource "aws_instance" "jenkins-master" {
#   ami           = var.ami
#   instance_type = var.instance-type
#   vpc_security_group_ids = [ aws_security_group.my-ssh-SG.id ]
#   availability_zone = var.availability-zone
#   key_name = var.key
#   user_data = file("${path.module}/script.sh")
   
#   tags = {
#     Name = var.instance-name
#   }

# }
