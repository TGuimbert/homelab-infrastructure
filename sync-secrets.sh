#!/usr/bin/env bash

# Check if logged in/unlocked
if ! bw status | grep -q "unlocked"; then
    export BW_SESSION=$(bw unlock --raw)
fi

echo "Pulling secrets from Bitwarden..."

# Fetch the content of the notes by name
bw get item "Homelab OpenTofu Backend" | jq -r '.notes' > opentofu/config.s3.tfbackend
bw get item "Homelab OpenTofu Vars" | jq -r '.notes' > opentofu/terraform.tfvars
bw get item "Homelab Ansible Vars" | jq -r '.notes' > ansible/group_vars/all

echo "✅ Files recreated. You can now run \`tofu init -backend-config=config.s3.tfbackend\`."
