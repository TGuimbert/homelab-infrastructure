output "provisioning_instructions" {
  value = <<-EOT
  1. PREP VM (Open Proxmox Console for VM ${proxmox_virtual_environment_vm.srv_01.vm_id}):
     echo -n password | sudo passwd -s

  2. DEPLOY NIXOS (Run from your local workstation in dotfile repository):
     ./scripts/bootstrap-srv-01.nu
  EOT
}

