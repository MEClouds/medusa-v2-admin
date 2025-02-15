#!/bin/bash

# Define variables
MONOREPO_URL="https://github.com/medusajs/medusa.git"
MONOREPO_PATH="/tmp/monorepo"  # Temporary clone location
MONOREPO_BRANCH="develop"
MONOREPO_SUBFOLDER="packages/admin/dashboard"
EXTRACTED_REPO_PATH="$(pwd)"  # Your repo

# Step 1: Clone monorepo with sparse-checkout (or update if already cloned)
if [ -d "$MONOREPO_PATH/.git" ]; then
    echo "Updating monorepo..."
    cd "$MONOREPO_PATH"
    git fetch origin "$MONOREPO_BRANCH"
    git checkout "$MONOREPO_BRANCH"
else
    echo "Cloning monorepo..."
    git clone --depth 1 --filter=blob:none --sparse -b "$MONOREPO_BRANCH" "$MONOREPO_URL" "$MONOREPO_PATH"
    cd "$MONOREPO_PATH"
    git sparse-checkout set "$MONOREPO_SUBFOLDER"
fi

# Step 2: Copy updated files to your repo (only changed files)
cd "$EXTRACTED_REPO_PATH"

# Merge updates instead of overwriting
git checkout monorepo/"$MONOREPO_BRANCH" -- "$MONOREPO_SUBFOLDER"

# Step 3: Handle conflicts manually if needed
echo "Merge complete. Resolve conflicts if necessary, then commit."

# Step 4: Commit & push changes (if any)
if ! git diff --quiet; then
    current_branch=$(git branch --show-current)
    read -p "Do you want to commit changes and push to $current_branch? (y/n): " choice
    if [[ "$choice" == [Yy]* ]]; then
        git add .
        git commit -m "Merged latest changes from monorepo on $(date)"
        git push origin "$current_branch"
        echo "Changes pushed to $current_branch!"
    else
        echo "Changes not pushed."
    fi
echo "Sync complete!"
else
    echo "No new changes to commit."
fi

echo "Sync complete!"
