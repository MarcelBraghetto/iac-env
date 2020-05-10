terraform {
  required_providers {
    aws = "~> 2.57.0"
    null = "~> 2.1.2"
  }
}

resource "null_resource" "create_file" {
  provisioner "local-exec" {
    command = "echo 'this is my first test' > foobar"
  }
}
