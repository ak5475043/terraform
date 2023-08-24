# variable users{
#     type = list
# }


output "list_of_users"{
        #value = "first user is ${var.users[0]}"
        value = "${join(",",var.users)}"
}

output "uppercase"{
        value = "${upper(var.users[0])}"
}

output "lowercase"{
        value = "${lower(var.users[2])}"
}

output "titlecase"{
        value = "${title(var.users[1])}"
}