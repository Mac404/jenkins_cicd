resource "aws_instance" "windows-server" {
     ami = var.win_ami
     instance_type = var.instance_type
     vpc_security_group_ids    = [aws_security_group.windows.id]
     key_name= "aws_keys_pairs"

 tags = {
    Name        = "${lower(var.app_name)}-${var.app_environment}-windows-server"
    Environment = var.app_environment
  }

 }

resource "tls_private_key" "terrafrom_generated_private_key" {
   algorithm = "RSA"
   rsa_bits  = 4096
 }
 
 resource "aws_key_pair" "generated_key" {
 
   # Name of key: Write the custom name of your key
   key_name   = "aws_keys_pairs"
 
   # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
   public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh
 
   # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
   provisioner "local-exec" {
     command = <<-EOT
       echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
       chmod 400 aws_keys_pairs.pem
     EOT
   }
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

  #3. Connection Block-
   connection {
     type        = "ssh"
     host        = self.public_ip
     user        = "ubuntu"
     
     # Mention the exact private key name which will be generated 
     private_key = file("aws_keys_pairs.pem")
     timeout     = "4m"

