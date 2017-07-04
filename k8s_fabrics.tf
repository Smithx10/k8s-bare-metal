resource "triton_fabric" "k8s" {
  vlan_id            =  "${triton_vlan.k8s.id}"
  name               = "k8s"
  description        = "k8s"
  subnet             = "10.50.1.0/24"
  gateway	     = "10.50.1.1"
  provision_start_ip = "10.50.1.10"
  provision_end_ip   = "10.50.1.240"
  resolvers          = ["192.168.1.102", "8.8.8.8"]
}

