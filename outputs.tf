output "subnet_id" {
    description = "The subnet ID of created resources" 
    value = "${aws_subnet.public_subnet.id}"
}
