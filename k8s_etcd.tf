resource "triton_machine" "k8s_etcd" {
  count = 3
  name  = "k8s_etcd_${format("%02d", count.index)}"

  package = "${var.k8s_etcd_package}"
  image   = "${var.k8s_etcd_image}"

  connection {
    type                = "ssh"
    host 		= "${self.primaryip}"
    user                = "root"
    private_key         = "${file(var.triton_key_path)}"
    agent               = "false"
    bastion_host        = "${triton_machine.k8s_bastion.0.primaryip}"
    bastion_private_key = "${file(var.triton_key_path)}"
  }

  nic {
    network = "${triton_fabric.k8s.id}"
  }

  tags {
    hostname = "k8s_etcd_${format("%02d", count.index)}"
    role     = "k8s_etcd"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i s/BOOTSTRAP_NODE_TEMPLATE/${triton_machine.k8s_etcd_bootstrap.primaryip}/g /lib/systemd/system/etcd.service",
      "sed -i s/CLUSTER_NAME_TEMPLATE/${self.tags.hostname}/g /lib/systemd/system/etcd.service",
      "systemctl start etcd",
    ]
  }
}

// -----------------------------------------------------------------------------


output "k8s_etcd_ips" {
  value = "${join(",", triton_machine.k8s_etcd.0.primaryip)}"
}
