module "multipass" {
  source       = "./multipass"
  workers      = var.workers
  masters      = var.masters
  kube_version = var.kube_version
}
