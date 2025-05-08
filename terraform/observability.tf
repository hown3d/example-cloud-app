resource "stackit_observability_instance" "example" {
  project_id = local.project_id
  name       = var.name
  plan_name  = "Observability-Basic-EU01"
  acl        = ["0.0.0.0/0"]
}
