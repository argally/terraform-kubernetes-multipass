resource "null_resource" "master-node" {
  depends_on = [null_resource.haproxy]

  triggers = {
    id = data.external.master[count.index].result.ip
  }

  connection {
    type        = "ssh"
    host        = data.external.master[count.index].result.ip
    user        = "root"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }

  provisioner "remote-exec" {
    script = "${path.module}/script/kube-init.sh"
  }

  provisioner "local-exec" {
    command = <<CMD
echo ${data.external.master[count.index].result.ip} master-${count.index} >> /tmp/hosts_ip.txt
CMD
  }

  provisioner "remote-exec" {
    inline = [
      "echo '*** Bind Kube-proxy 0.0.0.0 Metrics address:'",
      "kubectl -n kube-system get cm kube-proxy -o yaml |sed 's/metricsBindAddress: \"\"/metricsBindAddress: \"0.0.0.0:10249\"/' | kubectl apply -f -"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl -n kube-system patch ds kube-proxy -p '{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"updateTime\":\"`date +'%s'`'}}}}}"
    ]
  }
  count = 1
}
