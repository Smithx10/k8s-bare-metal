resource "triton_machine" "k8s_worker" {
  count = 3
  name  = "k8s_worker_${format("%02d", count.index)}"

  package = "${var.k8s_worker_package}"
  image = "${var.k8s_worker_image}"

  nic {
    network = "${triton_fabric.k8s.id}"
  }

  tags {
    hostname = "k8s_worker_${format("%02d", count.index)}"
    role = "k8s_worker"
  }
}

// -----------------------------------------------------------------------------

output "k8s_worker_ips" {
  value = "${join(",", triton_machine.k8s_worker.*.ips)}"
}
