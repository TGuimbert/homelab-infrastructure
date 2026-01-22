resource "proxmox_virtual_environment_download_file" "nixos_25_11_minimal_image" {
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = var.node_name
  url                = "https://channels.nixos.org/nixos-25.11/latest-nixos-minimal-x86_64-linux.iso"
  checksum           = "32d3b32c6f5a74977229eee77b60102459f317b891a5ec563255ac68d7368b09"
  checksum_algorithm = "sha256"
  upload_timeout     = 60 * 30
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "printer_mapping" {
  name = "printer-mapping"
  map = [
    {
      id   = var.printer_usb_id
      node = var.node_name
    },
  ]
}

resource "proxmox_virtual_environment_vm" "srv_01" {
  name        = "srv-01"
  description = "Managed by OpenTofu"
  tags        = ["opentofu", "nixos"]

  node_name = var.node_name
  vm_id     = 110

  agent {
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  boot_order = ["scsi0", "ide3", "net0"]

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
    floating  = 4096
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.nixos_25_11_minimal_image.id
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 64
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = "BC:24:11:0B:E3:41"
  }

  operating_system {
    type = "l26"
  }

  usb {
    mapping = proxmox_virtual_environment_hardware_mapping_usb.printer_mapping.name
  }

  serial_device {}

  lifecycle {
    ignore_changes = [
      # Prevents OpenTofu from overwriting manual 'optional=1' flag in the .conf file.
      # This allows the VM to boot even if the printer is powered off or disconnected.
      usb,
    ]
  }

  provisioner "local-exec" {
    # Make the printer usb mapping optional so that the printer can start without it.
    command = <<EOT
      ssh root@${self.node_name}.local "sed -i '/^usb0: mapping=${proxmox_virtual_environment_hardware_mapping_usb.printer_mapping.name}/ s/$/,optional=1/' /etc/pve/qemu-server/${self.vm_id}.conf"
    EOT
  }
}
