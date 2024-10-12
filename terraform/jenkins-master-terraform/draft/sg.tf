# data "aws_vpc" "default" {
#   default = true
# }

# resource "aws_security_group" "my-ssh-SG" {
#   name        = "todo-sg"
#   vpc_id = data.aws_vpc.default.id
#   description = "Allow ssh and port 8080"
#   tags = {
#     Name = "todo-sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
#   security_group_id = aws_security_group.my-ssh-SG.id
#   cidr_ipv4 = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_http" {
#   security_group_id = aws_security_group.my-ssh-SG.id
#   cidr_ipv4 = "0.0.0.0/0"
#   from_port         = 8080
#   ip_protocol       = "tcp"
#   to_port           = 8080
# }


# resource "aws_vpc_security_group_egress_rule" "allow-all1" {
#   security_group_id = aws_security_group.my-ssh-SG.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }