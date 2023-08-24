variable age {
    type = number
}

variable username {
    type=string
}

output user_info {
        value = "hello my name is ${var.username} my age is ${var.age}"
}