# Retrieve Triton credentials from env variables
provider "triton" {
  account = "${var.triton_account}"
  key_id  = "${var.triton_key_id}"
  key_material = "${file(var.triton_key_path)}"
  url = "${var.triton_url}"
}
