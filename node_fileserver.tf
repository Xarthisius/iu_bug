resource "openstack_compute_keypair_v2" "ssh_key" {
  name = "${var.cluster_name}"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_blockstorage_volume_v2" "test1-vol" {
  name = "${var.cluster_name}-test1-vol"
  description = "Shared volume for home directories"
  size = "${var.nfs_volume_size}"
}

resource "openstack_blockstorage_volume_v2" "test2-vol" {
  depends_on = ["openstack_blockstorage_volume_v2.test1-vol"]
  name = "${var.cluster_name}-test2-vol"
  description = "Shared volume for Docker registry"
  size = "${var.nfs_volume_size}"
}

resource "openstack_compute_instance_v2" "fileserver" {
  name = "test-nfs"
  image_name = "${var.image}"
  flavor_name = "${var.flavor}"
  key_pair = "${openstack_compute_keypair_v2.ssh_key.name}"
  user_data = "${file("config.ign")}"

  network {
    name = "public"
  }
}

resource "openstack_compute_volume_attach_v2" "test1-vol" {
  depends_on = ["openstack_compute_instance_v2.fileserver", "openstack_blockstorage_volume_v2.test1-vol"]
  instance_id = "${openstack_compute_instance_v2.fileserver.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.test1-vol.id}"
}

resource "openstack_compute_volume_attach_v2" "test2-vol" {
  depends_on = ["openstack_compute_instance_v2.fileserver", "openstack_blockstorage_volume_v2.test2-vol"]
  instance_id = "${openstack_compute_instance_v2.fileserver.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.test2-vol.id}"
}

output "Registry device" {
  value = "${openstack_compute_volume_attach_v2.test1-vol.device}"
}

output "Home device" {
  value = "${openstack_compute_volume_attach_v2.test2-vol.device}"
}
