output "provisioning_instructions" {
  value = <<-EOT
  1. PREP VM (Open Proxmox Console for VM ${proxmox_virtual_environment_vm.srv_01.vm_id}):
     sudo passwd
     ip a

  2. DEPLOY NIXOS (Run from your local workstation in dotfile repository):
     nix run github:nix-community/nixos-anywhere -- --flake .#${proxmox_virtual_environment_vm.srv_01.name} --target-host root@<vm_ip>
  EOT
}

