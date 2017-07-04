resource "triton_machine" "k8s_controller" {
  count = 1
  name  = "k8s_controller_${format("%02d", count.index)}"

  package = "${var.k8s_controller_package}"
  image   = "${var.k8s_controller_image}"

  nic {
    network = "${triton_fabric.k8s.id}"
  }

  tags {
    hostname = "k8s_controller_${format("%02d", count.index)}"
    role     = "k8s_controller"
  }
}

// -----------------------------------------------------------------------------

output "k8s_master_ip" {
  value = "${join(",", triton_machine.k8s_controller.0.primaryip)}"
}

output "k8s_controller_ips" {
  value = "${join(",", triton_machine.k8s_controller.*.ips)}"
}
