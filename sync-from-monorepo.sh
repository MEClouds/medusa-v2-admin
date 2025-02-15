#!/bin/bash

# Define variables
MONOREPO_URL="https://github.com/medusajs/medusa.git"
MONOREPO_PATH="/tmp/monorepo"  # Temporary location
MONOREPO_BRANCH="develop"  # Branch to fetch
MONOREPO_SUBFOLDER="packages/admin/dashboard"  # Path inside monorepo
EXTRACTED_REPO_PATH="$(pwd)"  # Your repo path

# Step 1: Clone only the required branch with sparse-checkout
if [ -d "$MONOREPO_PATH/.git" ]; then
    echo "Updating existing sparse-checkout..."
    cd "$MONOREPO_PATH"
    git fetch origin "$MONOREPO_BRANCH"
    git checkout "$MONOREPO_BRANCH"
else
    echo "Cloning monorepo with sparse-checkout..."
    git clone --depth 1 --filter=blob:none --sparse -b "$MONOREPO_BRANCH" "$MONOREPO_URL" "$MONOREPO_PATH"
    cd "$MONOREPO_PATH"
    git sparse-checkout set "$MONOREPO_SUBFOLDER"
fi

# Step 2: Sync only the required folder
rsync -av --delete "$MONOREPO_PATH/$MONOREPO_SUBFOLDER/" "$EXTRACTED_REPO_PATH/"

# Step 3: Commit & push changes (if any)
cd "$EXTRACTED_REPO_PATH"
if ! git diff --quiet; then
    git add .
    git commit -m "Sync with monorepo on $(date)"
    git push origin main  # Adjust if your branch is different
    echo "Changes pushed!"
else
    echo "No changes detected."
fi

echo "Sync complete!"
