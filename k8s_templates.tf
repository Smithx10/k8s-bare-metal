// kube-controller-manager.sh --------------------------------------------------

data "template_file" "start_controller_manager" {
  template   = "${file("${path.module}/scripts/kube-controller-manager.sh")}"
  depends_on = [
    "triton_machine.k8s_controller",
  ]

  vars {
    master_ip = "${triton_machine.k8s_controller.0.primaryip}"
  }
}

resource "local_file" "start_controller_manager" {
  content  = "${data.template_file.start_controller_manager.rendered}"
  filename = "${path.module}/output/kube-controller-manager.sh"
}

// kube-apiserver.sh -----------------------------------------------------------

data "template_file" "start_apiserver" {
  template   = "${file("${path.module}/scripts/kube-apiserver.sh")}"
  depends_on = [
    "triton_machine.k8s_controller",
  ]

  vars {
    controller_count = "${length(triton_machine.k8s_controller.*.primaryip)}"
    etcd_servers     = "${join(",", formatlist("\"%s\"", triton_machine.k8s_etcd.*.primaryip))}"
  }
}

resource "local_file" "start_apiserver" {
  content   = "${data.template_file.start_apiserver.rendered}"
  filename  = "${path.module}/output/kube-apiserver.sh"
}

// kubeconfig ------------------------------------------------------------------

data "template_file" "kubeconfig" {
  template   = "${file("${path.module}/templates/kubeconfig.tpl")}"
  depends_on = [
    "triton_machine.k8s_worker",
  ]

  vars {
    secret_token = "${var.secret_token}"
    master_ip    = "${triton_machine.k8s_controller.0.primaryip}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.module}/output/kubeconfig"
}

// kubelet.sh ------------------------------------------------------------------

data "template_file" "start_kubelet" {
  template   = "${file("${path.module}/scripts/kubelet.sh")}"
  depends_on = [
    "triton_machine.k8s_worker",
  ]

  vars {
    master_ip = "${triton_machine.k8s_controller.0.primaryip}"
  }
}

resource "local_file" "start_kubelet" {
  content  = "${data.template_file.start_kubelet.rendered}"
  filename = "${path.module}/output/kubelet.sh"
}

// kube-proxy.sh ---------------------------------------------------------------

data "template_file" "start_kube_proxy" {
  template   = "${file("${path.module}/scripts/kube-proxy.sh")}"
  depends_on = [
    "triton_machine.k8s_worker",
  ]

  vars {
    master_ip = "${triton_machine.k8s_controller.0.primaryip}"
  }
}

resource "local_file" "start_kube_proxy" {
  content  = "${data.template_file.start_kube_proxy.rendered}"
  filename = "${path.module}/output/kube-proxy.sh"
}

// token.csv -------------------------------------------------------------------

data "template_file" "token_csv" {
  template   = "${file("${path.module}/templates/token.csv.tpl")}"
  depends_on = [
    "triton_machine.k8s_controller",
  ]

  vars {
    secret_token = "${var.secret_token}"
  }
}

resource "local_file" "token_csv" {
  content  = "${data.template_file.token_csv.rendered}"
  filename = "${path.module}/output/token.csv"
}

// ssh.config ------------------------------------------------------------------

data "template_file" "ssh_config" {
  template = "${file("${path.module}/templates/ssh.config.tpl")}"

  vars {
    bastion_ip    = "${triton_machine.k8s_bastion.0.primaryip}"
    identity_file = "${var.triton_key_path}"
  }
}

resource "local_file" "ssh_config" {
  content   = "${data.template_file.ssh_config.rendered}"
  filename  = "${path.module}/output/ssh.config"
}

// ansible-inventory -----------------------------------------------------------

data "template_file" "controller_ansible" {
  count    = "${triton_machine.k8s_controller.count}"
  template = "${file("${path.module}/templates/hostname.tpl")}"

  depends_on = [
    "triton_machine.k8s_controller",
  ]

  vars {
    index = "${count.index + 1}"
    name  = "k8s_controller_${format("%02d", count.index)}"
    extra = " ansible_host=${element(triton_machine.k8s_controller.*.primaryip, count.index)}"
  }
}

data "template_file" "worker_ansible" {
  count    = "${triton_machine.k8s_worker.count}"
  template = "${file("${path.module}/templates/hostuser.tpl")}"

  depends_on = [
    "triton_machine.k8s_worker",
  ]

  vars {
    index = "${count.index + 1}"
    name  = "k8s_worker_${format("%02d", count.index)}"
    extra = " ansible_host=${element(triton_machine.k8s_worker.*.primaryip, count.index)}"
  }
}

data "template_file" "ansible_inventory" {
  template = "${file("${path.module}/templates/ansible_inventory.tpl")}"

  vars {
    bastion_ip       = "${triton_machine.k8s_bastion.0.primaryip}"
    controller_hosts = "${join("\n", data.template_file.controller_ansible.*.rendered)}"
    worker_hosts     = "${join("\n", data.template_file.worker_ansible.*.rendered)}"
  }
}

resource "local_file" "ansible_inventory" {
  content  = "${data.template_file.ansible_inventory.rendered}"
  filename = "${path.module}/output/ansible_inventory"
}
