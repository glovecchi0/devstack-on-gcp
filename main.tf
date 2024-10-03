locals {
  cloud_config_template_file            = "${path.cwd}/cloud-config.yml.tpl"
  cloud_config_file                     = "${path.cwd}/cloud-config.yml"
  horizon_config_template_file          = "${path.cwd}/horizon.conf.tpl"
  horizon_config_file                   = "${path.cwd}/horizon.conf"
  horizon_config_file_name              = "horizon.conf"
  update_endpoints_script_template_file = "${path.cwd}/update_endpoints.sh.tpl"
  update_endpoints_script_file          = "${path.cwd}/update_endpoints.sh"
  update_endpoints_script_file_name     = "update_endpoints.sh"
  private_ssh_key_path                  = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  public_ssh_key_path                   = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
}

resource "local_file" "cloud_config" {
  content = templatefile("${local.cloud_config_template_file}", {
    devstack_adm_password    = var.devstack_adm_password,
    devstack_db_password     = var.devstack_db_password,
    devstack_rabbit_password = var.devstack_rabbit_password,
    devstack_svc_password    = var.devstack_svc_password
  })
  file_permission = "0644"
  filename        = local.cloud_config_file
}

data "cloudinit_config" "conf" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content      = local_file.cloud_config.content
    filename     = local_file.cloud_config.filename
  }
}

resource "tls_private_key" "ssh_private_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.private_ssh_key_path
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.public_ssh_key_path
  content         = tls_private_key.ssh_private_key[0].public_key_openssh
  file_permission = "0600"
}

resource "google_compute_network" "vpc" {
  count                   = var.create_vpc == true ? 1 : 0
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  depends_on    = [resource.google_compute_firewall.firewall[0]]
  count         = var.create_vpc == true ? 1 : 0
  name          = "${var.prefix}-subnet"
  region        = var.region
  network       = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
  ip_cidr_range = var.ip_cidr_range
}

resource "google_compute_firewall" "firewall" {
  count   = var.create_firewall ? 1 : 0
  name    = "${var.prefix}-firewall"
  network = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80", "9696"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}"]
}

data "google_compute_zones" "available" {
  region = var.region
}

resource "random_string" "random" {
  length  = 4
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "google_compute_instance" "vm" {
  count        = var.instance_count
  name         = "${var.prefix}-vm-${count.index + 1}-${random_string.random.result}"
  machine_type = var.instance_type
  zone         = data.google_compute_zones.available.names[count.index % 3]
  tags         = ["${var.prefix}"]
  boot_disk {
    initialize_params {
      size  = var.instance_disk_size
      type  = var.disk_type
      image = var.os_image
    }
  }
  scratch_disk {
    interface = "SCSI"
  }
  network_interface {
    network    = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
    subnetwork = var.subnet == null ? resource.google_compute_subnetwork.subnet[0].name : var.subnet
    access_config {}
  }
  metadata = {
    ssh-keys  = var.create_ssh_key_pair ? "${var.ssh_username}:${tls_private_key.ssh_private_key[0].public_key_openssh}" : "${var.ssh_username}:${local.public_ssh_key_path}"
    user-data = "${data.cloudinit_config.conf.rendered}"
  }
}

resource "null_resource" "wait_devstack_services_startup" {
  depends_on = [resource.google_compute_instance.vm]
  provisioner "local-exec" {
    command     = <<-EOF
      count=0
      while [ "$${count}" -lt 15 ]; do
        resp=$(curl -k -s -o /dev/null -w "%%{http_code}" $${DEVSTACK_URL})
        echo "Waiting for $${DEVSTACK_URL} - response: $${resp}"
        if [ "$${resp}" = "200" ]; then
          ((count++))
        fi
        sleep 2
      done
      EOF
    interpreter = ["/bin/bash", "-c"]
    environment = {
      DEVSTACK_URL = "http://${google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip}/dashboard/auth/login/?next=/dashboard/"
    }
  }
}

data "local_file" "ssh_private_key" {
  depends_on = [null_resource.wait_devstack_services_startup]
  filename   = local.private_ssh_key_path
}

resource "local_file" "horizon_config" {
  depends_on = [data.local_file.ssh_private_key]
  content = templatefile("${local.horizon_config_template_file}", {
    public_ip = google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip
  })
  file_permission = "0644"
  filename        = local.horizon_config_file
}

resource "null_resource" "copy_horizon_config" {
  depends_on = [local_file.horizon_config]
  provisioner "file" {
    source      = local.horizon_config_file
    destination = "/tmp/${local.horizon_config_file_name}"
  }
  connection {
    host        = google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    agent       = "false"
    user        = var.ssh_username
    private_key = data.local_file.ssh_private_key.content
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/${local.horizon_config_file_name} /etc/apache2/sites-available/${local.horizon_config_file_name}",
      "sudo a2enmod ssl",
      "sudo a2ensite ${local.horizon_config_file_name}",
      "sudo service apache2 restart"
    ]
    connection {
      type        = "ssh"
      host        = google_compute_instance.vm[0].network_interface[0].access_config[0].nat_ip
      user        = var.ssh_username
      private_key = data.local_file.ssh_private_key.content
    }
  }
}

resource "local_file" "update_endpoints_script" {
  depends_on = [data.local_file.ssh_private_key]
  content = templatefile("${local.update_endpoints_script_template_file}", {
    public_ip             = google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip,
    devstack_adm_password = var.devstack_adm_password
  })
  file_permission = "0644"
  filename        = local.update_endpoints_script_file
}

resource "null_resource" "copy_update_endpoints_script" {
  depends_on = [local_file.update_endpoints_script]
  provisioner "file" {
    source      = local.update_endpoints_script_file
    destination = "/tmp/${local.update_endpoints_script_file_name}"
  }
  connection {
    host        = google_compute_instance.vm[0].network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    agent       = "false"
    user        = var.ssh_username
    private_key = data.local_file.ssh_private_key.content
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/${local.update_endpoints_script_file_name} /home/stack/${local.update_endpoints_script_file_name}",
      "sudo bash /home/stack/${local.update_endpoints_script_file_name}",
      "sudo rm /home/stack/${local.update_endpoints_script_file_name}"
    ]
    connection {
      type        = "ssh"
      host        = google_compute_instance.vm[0].network_interface[0].access_config[0].nat_ip
      user        = var.ssh_username
      private_key = data.local_file.ssh_private_key.content
    }
  }
}

/*
resource "openstack_images_image_v2" "basic_image" {
  depends_on       = [null_resource.copy_update_endpoints_script]
  name             = var.devstack_image_name
  image_source_url = var.devstack_image_source_url
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "shared"
}

data "openstack_images_image_v2" "basic_image_id" {
  depends_on = [openstack_images_image_v2.basic_image]
  name       = var.devstack_image_name
}

resource "openstack_compute_instance_v2" "basic" {
  depends_on      = [data.openstack_images_image_v2.basic_image_id]
  name            = "basic"
  image_id        = data.openstack_images_image_v2.basic_image_id.id
  flavor_name     = var.devstack_flavor_name
  security_groups = ["${var.devstack_security_group}"]
  network {
    name = var.devstack_network_name
  }
}
*/
