resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = "t2.micro"
  vpc_security_group_ids = var.sg-id
  key_name = var.key-name
  user_data = var.user-data
  root_block_device {
    volume_size = 20  # New size for root EBS volume (increase size here)
    volume_type = "gp3"
  }
  tags = {
    Name = var.name
  }

  }