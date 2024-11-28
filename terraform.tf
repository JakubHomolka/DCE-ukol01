terraform {
  required_providers {
    opennebula = {
      source = "OpenNebula/opennebula"
      version = "~> 1.2"
    }
  }
}

provider "opennebula" {
  endpoint      = "${var.opennebula_endpoint}"
  username      = "${var.opennebula_username}"
  password      = "${var.opennebula_password}"
}

# Configurable backend nodes
resource "opennebula_virtual_machine" "backend-node" {
  count        = var.backend_count
  name         = "backend-${count.index + 1}"
  description  = "Backend Node"
  cpu          = 1
  vcpu         = 1
  memory       = 1024
  permissions  = "600"
  group        = "users"

  context = {
    NETWORK  = "YES"
    HOSTNAME = "$NAME"
    SSH_PUBLIC_KEY = file("id_ecdsa.pub")
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = 687
    target   = "vda"
    size     = 12000 
  }

  graphics {
    listen = "0.0.0.0"
    type   = "vnc"
  }

  nic {
    network_id = 3
  }

  connection {
    type = "ssh"
    user = "root"
    host = "${self.ip}"
    private_key = file("id_ecdsa")  
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive", 
      "apt -y update",
      "apt -y upgrade",
     ]
  }
}

# Load balancer (NGINX)
resource "opennebula_virtual_machine" "load-balancer" {
  name         = "nginx-load-balancer"
  description  = "NGINX Load Balancer"
  cpu          = 1
  vcpu         = 1
  memory       = 1024
  permissions  = "600"
  group        = "users"

  context = {
    NETWORK       = "YES"
    HOSTNAME      = "$NAME"
    SSH_PUBLIC_KEY = file("id_ecdsa.pub")
  }

  os {
    arch = "x86_64"
    boot = "disk0"
  }

  disk {
    image_id = 687 
    target   = "vda"
    size     = 12000
  }

  nic {
    network_id = 3
  }

  connection {
    type        = "ssh"
    user        = "root"
    host        = "${self.ip}"
    private_key = file("id_ecdsa") 
  }
}

# Outputs
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
      vm_admin_user = var.vm_admin_user,
      load_balancer = [opennebula_virtual_machine.load-balancer.ip],
      backend_nodes = opennebula_virtual_machine.backend-node.*.ip,
      ssh_key = var.ssh_key
    })
  filename = "ansible/inventory"
}

resource "local_file" "nginx_config" {
  content = templatefile("nginx.conf.tmpl",
    {
      backend_nodes = opennebula_virtual_machine.backend-node.*.ip
    })
  filename = "ansible/roles/load_balancer/templates/nginx.conf.j2"
}