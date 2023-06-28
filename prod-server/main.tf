resource "aws_instance" "prod-server" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.micro"
  key_name               = "myprojetct01"
  vpc_security_group_ids = ["sg-00de37b3b55eb6077"]
  tags = {
    Name = "prod-server"
  }
  
  provisioner "local-exec" {
    command = "sleep 60 && echo 'Instance ready'"
  }
  
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./mtprojetct01.pem")
    host        = self.public_ip 
  }
   
  provisioner "local-exec" {
    command = "echo ${aws_instance.prod-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/finance-project/prod-server/deploy.yml"
  }
}

