data "external" "haproxy" {
  program = ["python3", "${path.module}/script/multipass.py"]
  query = {
    name = "haproxy"
    cpu  = var.cpu_haproxy
    mem  = var.mem_haproxy
    disk = var.disk_haproxy
    init = local_file.cloud_init_haproxy.content
  }
}

data "external" "master" {
  program = ["python3", "${path.module}/script/multipass.py"]
  query = {
    name = "master-${count.index}"
    cpu  = var.cpu
    mem  = var.mem
    disk = var.disk
    init = local_file.cloud_init_master.content
  }
  count      = 1
  depends_on = [data.external.haproxy]
}

data "external" "masters" {
  program = ["python3", "${path.module}/script/multipass.py"]
  query = {
    name = "master-${count.index + 1}"
    cpu  = var.cpu
    mem  = var.mem
    disk = var.disk
    init = local_file.cloud_init_masters.content
  }
  count      = var.masters >= 3 ? var.masters - 1 : 0
  depends_on = [data.external.master]
}

data "external" "workers" {
  program = ["python3", "${path.module}/script/multipass.py"]
  query = {
    name = "worker-${count.index}"
    cpu  = var.cpu_worker
    mem  = var.mem_worker
    disk = var.disk_worker
    init = local_file.cloud_init_workers.content
  }
  count      = var.workers >= 1 ? var.workers : 0
  depends_on = [data.external.masters]
}

data "external" "kubejoin-master" {
  depends_on = [null_resource.master-node]
  program = ["ssh",
    "-i", pathexpand("~/.ssh/id_rsa"),
    "-o", "StrictHostKeyChecking=no",
    "-l", "root",
    data.external.master[0].result.ip,
    "cat", "/etc/join-master.json"
  ]
}

data "external" "kubejoin" {
  depends_on = [null_resource.master-node]
  program = ["ssh",
    "-i", pathexpand("~/.ssh/id_rsa"),
    "-o", "StrictHostKeyChecking=no",
    "-l", "root",
    data.external.master[0].result.ip,
    "cat", "/etc/join.json"
  ]
}
