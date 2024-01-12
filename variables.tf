variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "ami" {
   type        = string
   description = "Ubuntu AMI ID"
   default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
   type        = string
   description = "Instance type"
   default     = "t2.micro"
}

variable "name_tag" {
   type        = string
   description = "Name of the EC2 instance"
   default     = "My EC2 Instance"
}

variable "vpc_name" {
  type    = string
  default = "Project VPC"
}

variable "app_name" {
   type        = string
   description = "Instance type"
   default     = "windows"
}
variable "app_environment" {
   type        = string
   description = "Instance type"
   default     = "prod"
}

variable "aws_key_name" {
   type        = string
   description = "Instance type"
   default     = "win_key"
}


