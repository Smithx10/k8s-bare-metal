resource "triton_vlan" "k8s" {
  vlan_id     = 50
  name        = "k8s"
  description = "K8S VLAN"
}
