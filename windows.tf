resource "aws_instance" "windows-server" {
     ami = var.win_ami
     instance_type = var.instance_type
     vpc_security_group_ids    = [aws_security_group.jenkins_sg.id]
     key_name = var.aws_key_name

 tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-windows-server"
    Environment = var.app_environment
  }

 }

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${lower(var.app_name)}-${lower(var.app_environment)}-windows-${lower(var.aws_region)}"  
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}
