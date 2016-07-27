provider "openstack" {
    user_name   = "USER_NAME"
    tenant_name = "TENANT_NAME"
    password    = "PASSWORD"
    auth_url    = "AUTH_URL"
}

resource "openstack_compute_floatingip_v2" "floatip_1" {
  pool = "ext_net"
}

resource "openstack_compute_instance_v2" "goto_tf_test" {
  name       = "goto-tf-test"
  image_id   = "87c37d2b-47be-4c7a-acd1-95f4b5ef2ae4"
  flavor_id  = "fbeaa0af-acb3-4935-8c7b-6342007c6e5e"
  key_pair   = "id_rsa_iij"
  security_groups = ["default","ssh.cybird"]
  floating_ip = "${openstack_compute_floatingip_v2.floatip_1.address}"

  metadata {
    this = "that"
  }

  network {
    name = "int_net"
  }
}