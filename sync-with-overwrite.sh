#!/bin/bash

# Define variables
MONOREPO_URL="https://github.com/medusajs/medusa.git"
MONOREPO_PATH="/tmp/monorepo"  # Temporary clone location
MONOREPO_BRANCH="develop"
MONOREPO_SUBFOLDER="packages/admin/dashboard"
EXTRACTED_REPO_PATH="$(pwd)"  # Your repo

# List of files to exclude
EXCLUDE_FILES=(
    "sync-with-merge.sh"
    "sync-with-overwrite.sh"
    "README.md"
    ".yarnrc.yml"
)

# Convert list to rsync format
EXCLUDE_PARAMS=""
for FILE in "${EXCLUDE_FILES[@]}"; do
    EXCLUDE_PARAMS+="--exclude=$FILE "
done

# Step 1: Clone monorepo with sparse-checkout (or update if already cloned)
if [ -d "$MONOREPO_PATH/.git" ]; then
    echo "Updating monorepo..."
    cd "$MONOREPO_PATH"
    git fetch origin "$MONOREPO_BRANCH"
    git reset --hard origin/"$MONOREPO_BRANCH"
else
    echo "Cloning monorepo..."
    git clone --depth 1 --filter=blob:none --sparse -b "$MONOREPO_BRANCH" "$MONOREPO_URL" "$MONOREPO_PATH"
    cd "$MONOREPO_PATH"
    git sparse-checkout set "$MONOREPO_SUBFOLDER"
fi

# Step 2: Overwrite local files with monorepo version but exclude certain files
rsync -av --delete $EXCLUDE_PARAMS "$MONOREPO_PATH/$MONOREPO_SUBFOLDER/" "$EXTRACTED_REPO_PATH/"

# Step 3: Force commit & push (preserve excluded files)
cd "$EXTRACTED_REPO_PATH"
git add .
git commit -m "Overwritten with latest monorepo changes (excluding specific files) on $(date)"
git push origin main --force  # Adjust branch if necessary

echo "Sync complete! Excluded files were preserved."
