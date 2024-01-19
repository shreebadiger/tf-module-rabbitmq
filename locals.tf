locals {
    project_name = lookup(var.tags,"project_name",null)
    prefix ="${var.env}-${local.project_name}"
    name = "${var.env}-${local.project_name}-rabbitmq"
}