variable "az" {
    description = "Controls availability zone for subnet"
    default = "ap-southeast-2a"
}
variable "example_trusted" {
    description = "Trusted network address space" 
    default = ["10.10.10.10/24"]
}
