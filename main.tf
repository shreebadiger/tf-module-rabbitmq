resource "aws_security_group" "main" {
  name        = local.name
  description = local.name
  vpc_id      = var.vpc_id

  ingress {
    description      = "RABBITMQ"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = var.sg_cidrs
  }

   ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.bastion_cidrs
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = merge(var.tags, {Name = local.name})

}

resource "aws_instance" "main" {
    ami = data.aws_ami.ami.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.main.id]
    subnet_id = var.subnets[0]
    tags = merge(var.tags, {Name = local.name})

    user_data_base64 = base64encode(templatefile("${path.module}/userdata.sh", {
    env = var.env
  }))
  
}

resource "aws_route53_record" "main" {
  name    = "rabbitmq-${var.env}"
  type    = "CNAME"
  ttl     = 30
  zone_id =var.route53_zone_id
  records = [aws_instance.main.private_ip]
  
  }