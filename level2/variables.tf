variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "area_code" {
  description = "Area code"
  type        = string
  default     = "name"
}

variable "key_name" {
  description = "SSH key"
  type        = string
  default     = "main11"
}
