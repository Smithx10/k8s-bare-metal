data "template_file" "certificates" {
  template = "${file("${path.module}/templates/kubernetes-csr.json")}"

  vars {
    controller_ips = "${join(",", formatlist("\"%s\"", triton_machine.k8s_controller.*.primaryip))}"
    worker_ips = "${join(",", formatlist("\"%s\"", triton_machine.k8s_worker.*.primaryip))}"
    etcd_ips = "${join(",", formatlist("\"%s\"", triton_machine.k8s_etcd.*.primaryip))}"
  }
}

resource "null_resource" "certificates" {
  triggers {
    template_rendered = "${data.template_file.certificates.rendered}"
  }

  provisioner "local-exec" {
    command = "echo '${data.template_file.certificates.rendered}' > cert/kubernetes-csr.json"
  }

  provisioner "local-exec" {
    command = "cd cert; cfssl gencert -initca ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }

  provisioner "local-exec" {
    command = "mkdir -p output/ && cp cert/ca.pem cert/kubernetes-key.pem cert/kubernetes.pem output/"
  }
}
