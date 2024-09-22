variable "db_username" {
  type      = string
  sensitive = true
  default   = "username"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "password"
}