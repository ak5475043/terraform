provider "github" {
  token = "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"
}

resource "github_repository" "terraform-first-repo" {
  name        = "first_terraform_repo"
  description = "first resource using terraform"

  visibility = "public"
  auto_init  = true

}

# resource "github_repository" "terraform-second-repo" {
#   name        = "second_terraform_repo"
#   description = "second resource using terraform"

#   visibility = "public"
#   auto_init = true

# }


output "terraform-first-repo-url" {
  value = github_repository.terraform-first-repo.html_url
}