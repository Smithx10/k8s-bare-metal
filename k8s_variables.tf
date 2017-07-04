variable triton_account {
  description 	= "The same SDC_ACCOUNT used by the Triton CLI"
}

variable triton_key_id {
  description 	= "The same SDC_KEY_ID used by the Triton CLI"
}

variable triton_url {
  description 	= "The same SDC_URL used by the Triton CLI"
}

variable triton_key_path {
  description 	= "Path to the SSH private key used by Triton"
}

# head /dev/urandom | base32 | head -c 8
variable secret_token {
  description 	= "Secret token used by Kubernetes for securing the API server"
  default 	= "UWZ6OBSL"
}

variable bastion_user {
  description 	= "If using an LX ubuntu image we'll use root, otherwise ubuntu"
  default 	= "root"
}

variable k8s_bastion_public_key {
  description 	= "Public SSH key for the private key used across all nodes"
}

variable triton_public_network {
  description 	= "The UUID of a public fabric network"
}

variable default_user {
  description 	= "Default user account typically used to SSH into each machine"
  default 	= "ubuntu"
}

variable k8s_bastion_package {
  description 	= "Package which defines the compute attributes of a bastion"
}

variable k8s_etcd_package {
  description 	= "Package which defines the compute attributes of a etcd"
}

variable k8s_etcd_cluster_name {
  description 	= "Package which defines the compute attributes of the etcd cluster name"
}

variable k8s_controller_package {
  description 	= "Package which defines the compute attributes of a controller"
}

variable k8s_worker_package {
  description 	= "Package which defines the compute attributes of a worker"
}

variable k8s_bastion_image {
  description 	= "The UUID of your k8s-bastion-lx-16.04 image"
}

variable k8s_etcd_image {
  description 	= "The UUID of your k8s-etcd-lx-16.04 image"
}

variable k8s_controller_image {
  description 	= "The UUID of your k8s-controller-lx-16.04 image"
}

variable k8s_worker_image {
  description 	= "The UUID of your k8s-worker-kvm-16.04 image"
}

