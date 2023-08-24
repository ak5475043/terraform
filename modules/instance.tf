module "mywebserver" {
    source = "./modules/webserver"
    image_id = "abcdefch"
    instance_type = "t2.micro"
    key = file("${path.module}/id_rsa.pub")
}


output publicIp {
    value = module.mywebserver.publicIP
}