#variable username {}

output "name" {
        value = "hello ${var.username} your age is ${var.age}"
}