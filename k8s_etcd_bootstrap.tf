resource "triton_machine" "k8s_etcd_bootstrap" {
  count = 1
  name  = "k8s_etcd_bootstrap_${format("%02d", count.index)}"

  package = "${var.k8s_etcd_package}"
  image   = "${var.k8s_etcd_image}"

  connection {
    type 		= "ssh"
    user 		= "root"
    host 		= "${self.primaryip}"
    private_key 	= "${file(var.triton_key_path)}"
    agent		= "false"
    bastion_host 	= "${triton_machine.k8s_bastion.0.primaryip}"
    bastion_private_key = "${file(var.triton_key_path)}"
  }

  nic {
    network = "${triton_fabric.k8s.id}"
  }

  tags {
    hostname = "k8s_etcd_bootstrap_${format("%02d", count.index)}"
    role     = "k8s_etcd_bootstrap"
  }
  
  provisioner "remote-exec" {
    inline = [
      "systemctl start etcd-bootstrap",
      "sleep 5",
      "curl localhost -sL -X PUT --fail -d value=3 http://localhost:4001/v2/keys/discovery/E0DE385F-3781-45E7-9C7C-60AAF964C89B/_config/size",
    ]
  }
}

// -----------------------------------------------------------------------------


output "k8s_etcd_bootstrap_ips" {
  value = "${join(",", triton_machine.k8s_etcd_bootstrap.0.primaryip)}"
}
