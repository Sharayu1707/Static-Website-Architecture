variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
  default = "vpc-00012fe1fb6f11a06"
}

variable "public_subnets" {
  type = list(string)
  default = [
    "subnet-02aa64820c275928a",
    "subnet-0af4352a9bdf8e422"
  ]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type = string
  default = "ami-0d176f79571d18a8f"
}

variable "repo_url" {
  type    = string
  default = "https://github.com/Sharayu1707/Static-Website-Architecture.git"
}

variable "email_address" {
  type = string
  default = "sharayunimbalkar07@gmail.com"
}
