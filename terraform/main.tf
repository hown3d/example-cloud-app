
locals {
  project_id = var.project_id
}



resource "stackit_secretsmanager_instance" "this" {
  project_id = local.project_id
  name       = "myinstance"
}

resource "stackit_secretsmanager_user" "this" {
  project_id    = local.project_id
  instance_id   = stackit_secretsmanager_instance.this.instance_id
  description   = "TF User"
  write_enabled = true
}

output "vault_id" {
  value = stackit_secretsmanager_instance.this.instance_id
}

output "vault_username" {
  value = stackit_secretsmanager_user.this.username
}

