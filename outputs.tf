
output "aws_vm_private_key" {
    value = tls_private_key.aws_vm_key.private_key_pem
}

output "aws_vm_instance_ip" {
    depends_on = [aws_eip.aws_demo-eip]
    value = "${aws_eip.aws_demo-eip.public_ip}"
}