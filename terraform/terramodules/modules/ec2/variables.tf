variable "ami" {
  type = string
  default = "ami-0da424eb883458071"
}


variable "sg-id" {
  type = list(string)
}

variable "user-data" {
  type = string
  default = ""
}

variable "key-name" {
  type = string
}

variable "name" {
  type = string
}
