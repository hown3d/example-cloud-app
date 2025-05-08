
resource "stackit_postgresflex_instance" "db" {
  project_id      = local.project_id
  name            = var.name
  acl             = ["0.0.0.0/0"]
  backup_schedule = "00 00 * * *"
  flavor = {
    cpu = 2
    ram = 4
  }
  replicas = 1
  storage = {
    class = "premium-perf2-stackit"
    size  = 25
  }
  version = 16
}


resource "stackit_postgresflex_user" "db" {
  project_id  = local.project_id
  instance_id = stackit_postgresflex_instance.db.instance_id
  username    = "myuser"
  roles       = ["login"]
}

resource "stackit_postgresflex_database" "db" {
  project_id  = local.project_id
  owner       = stackit_postgresflex_user.db.username
  instance_id = stackit_postgresflex_instance.db.instance_id
  name        = "stackit"
}


resource "vault_kv_secret_v2" "db" {
  mount               = stackit_secretsmanager_instance.this.instance_id
  name                = "db"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      db_uri = stackit_postgresflex_user.db.uri
    }
  )
}
