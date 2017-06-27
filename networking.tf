resource "triton_fabric" "k8s" {
  vlan_id            =  0		
  name               = "k8s"
  description        = "k8s"
  subnet             = "10.50.1.0/24"
  provision_start_ip = "10.50.1.10"
  provision_end_ip   = "10.50.1.240"
  resolvers          = ["192.168.1.102", "8.8.8.8"]
}

resource "triton_firewall_rule" "etcd_docker" {
  rule = "FROM subnet 10.20.0.0/24 TO tag \"docker:label:com.docker.compose.service\" = \"etcd\" ALLOW tcp (PORT 2379 AND PORT 2380 AND PORT 4001)"
  enabled = true
}
