variable "region" {
    default = "RegionOne"
}

variable "image" {
    default = "Container-Linux (1632.1.0 Beta)"
    description = "openstack image list : Name"
}

variable "flavor" {
    default = "m1.small"
    description = "openstack flavor list : Name"
}

variable "ssh_key_file" {
    default = "~/.ssh/id_rsa"
    description = "Path to pub key (assumes it ends with .pub)"
}

variable "ssh_user_name" {
    default = "core"
    description = "Image specific user"
}

variable "docker_mtu" {
    default = "8960"
    description = "Docker MTU"
}

variable "nfs_volume_size" {
    default =  100
    description = "Fileserver volume size in GB"
}

variable "cluster_name" {
    default = "ala"
    description = "Cluster name"
}

