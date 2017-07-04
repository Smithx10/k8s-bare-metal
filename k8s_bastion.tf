resource "triton_machine" "k8s_bastion" {
  count 	= 1
  name  	= "k8s_bastion_${format("%02d", count.index)}"
  package 	= "${var.k8s_bastion_package}"
  image 	= "${var.k8s_bastion_image}"
  
  nic {
    network 	= "${var.triton_public_network}"
  }

  nic {
    network 	= "${triton_fabric.k8s.id}"
  }

  tags {
    hostname 	= "k8s_bastion_${format("%02d", count.index)}"
    role 	= "k8s_bastion"
  }

}

// -----------------------------------------------------------------------------

output "k8s_bastion_ips" {
  value = "${join(",", triton_machine.k8s_bastion.*.ips)}"
}
