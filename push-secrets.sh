#!/usr/bin/env bash

# Ensure files exist before trying to upload
if [[ ! -f "config.s3.tfbackend" || ! -f "terraform.tfvars" ]]; then
    echo "Error: config.s3.tfbackend or terraform.tfvars not found locally."
    exit 1
fi

# Check if logged in/unlocked
if ! bw status | grep -q "unlocked"; then
    export BW_SESSION=$(bw unlock --raw)
fi

echo "Uploading secrets to Bitwarden..."

# Function to update a Secure Note's content
update_note() {
    local note_name="$1"
    local file_path="$2"
    
    echo "Processing $note_name..."
    
    # 1. Get the JSON object of the existing item
    ITEM_JSON=$(bw get item "$note_name")
    
    if [ -z "$ITEM_JSON" ]; then
        echo "Error: Could not find Bitwarden item named '$note_name'"
        return
    fi

    # 2. Extract the ID
    ITEM_ID=$(echo "$ITEM_JSON" | jq -r '.id')
    
    # 3. Read the local file content
    NEW_CONTENT=$(cat "$file_path")

    # 4. Update the 'notes' field in the JSON and encode it back to the vault
    # We use jq to swap the notes field while keeping everything else (ID, name, folder) the same
    echo "$ITEM_JSON" | jq --arg notes "$NEW_CONTENT" '.notes = $notes' | bw encode | bw edit item "$ITEM_ID" > /dev/null

    echo "✅ $note_name updated successfully."
}

# Run for both files
update_note "Homelab OpenTofu Backend" "config.s3.tfbackend"
update_note "Homelab OpenTofu Vars" "terraform.tfvars"

echo "Done. Your vault is now in sync with your local machine."
