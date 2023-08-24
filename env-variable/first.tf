variable username {
    type = string
}

output greetings{
        value = "hello ${var.username}"
}


#export TF_VAR_username=ayush2107