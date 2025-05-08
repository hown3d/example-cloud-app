provider "kubernetes" {
  host                   = yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).clusters[0].cluster.server
  client_certificate     = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).users[0].user["client-certificate-data"])
  client_key             = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).users[0].user["client-key-data"])
  cluster_ca_certificate = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).clusters[0].cluster["certificate-authority-data"])
}

provider "helm" {
  kubernetes {
    host                   = yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).clusters[0].cluster.server
    client_certificate     = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).users[0].user["client-certificate-data"])
    client_key             = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).users[0].user["client-key-data"])
    cluster_ca_certificate = base64decode(yamldecode(stackit_ske_kubeconfig.ske_kubeconfig_01.kube_config).clusters[0].cluster["certificate-authority-data"])
  }

}

resource "helm_release" "externalsecrets" {
  name       = "externalsecrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
}

resource "stackit_dns_zone" "this" {
  project_id = local.project_id
  name       = "${var.name}.runs.onstackit.cloud"
  dns_name   = "${var.name}.runs.onstackit.cloud"
}

resource "stackit_ske_cluster" "this" {
  project_id             = local.project_id
  name                   = var.name
  kubernetes_version_min = "1.31"
  node_pools = [
    {
      name               = "workers"
      machine_type       = "c1.2"
      minimum            = "3"
      maximum            = "6"
      availability_zones = ["eu01-3", "eu01-1", "eu01-2"]
    }
  ]
  extensions = {
    argus = {
      enabled           = true
      argus_instance_id = stackit_observability_instance.example.instance_id
    }
    dns = {
      enabled = true
      zones = [
        stackit_dns_zone.this.dns_name
      ]
    }
  }
  maintenance = {
    enable_kubernetes_version_updates    = true
    enable_machine_image_version_updates = true
    start                                = "01:00:00Z"
    end                                  = "02:00:00Z"
  }
}


resource "stackit_ske_kubeconfig" "ske_kubeconfig_01" {
  project_id   = local.project_id
  cluster_name = stackit_ske_cluster.this.name
  refresh      = true
}



resource "kubernetes_secret" "clustersecretstore_password" {
  metadata {
    name      = "vault-secret"
    namespace = "kube-system"
  }

  data = {
    PASSWORD = stackit_secretsmanager_user.this.password
  }
}
