resource "aws_instance" "windows-server" {
     ami = var.win_ami
     instance_type = var.instance_type
     vpc_security_group_ids    = [aws_security_group.windows.id]
     key_name = aws_key_pair.key_pair.id

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
   provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
   command = "echo '${tls_private_key.key_pair.private_key_pem}' > ./myKey.pem"
}


#Create security group 
resource "aws_security_group" "windows" {
  #Allow incoming TCP requests on port 22 from any IP
  name        = "jenkins2"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["69.42.6.44/32" , "98.51.2.169/32", "71.198.26.65/32" ]
  }
# Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
