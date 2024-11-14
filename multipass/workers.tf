resource "null_resource" "workers-node" {
  depends_on = [null_resource.master-node]

  triggers = {
    id = data.external.workers[count.index].result.ip
  }

  connection {
    type        = "ssh"
    host        = data.external.workers[count.index].result.ip
    user        = "root"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/signal ]; do sleep 2; done"
    ]
  }
  provisioner "local-exec" {
    command = <<CMD
echo ${data.external.workers[count.index].result.ip} worker-${count.index} >> /tmp/hosts_ip.txt
CMD
  }
  count = var.workers >= 1 ? var.workers : 0
}


resource "null_resource" "workers-node_labels" {
  depends_on = [null_resource.workers-node]

  triggers = {
    id = data.external.workers[count.index].result.ip
  }

  connection {
    type        = "ssh"
    host        = data.external.master[0].result.ip
    user        = "root"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /tmp/signal ]; do sleep 2; done"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "kubectl label --overwrite node worker-${count.index} worker_group=managed kubernetes.io/role=worker"
    ]
  }
  count = var.workers >= 1 ? var.workers : 0
}