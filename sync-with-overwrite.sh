#!/bin/bash

# Define variables
MONOREPO_URL="https://github.com/medusajs/medusa.git"
MONOREPO_PATH="/tmp/monorepo"  # Temporary clone location
MONOREPO_BRANCH="develop"
MONOREPO_SUBFOLDER="packages/admin/dashboard"
EXTRACTED_REPO_PATH="$(pwd)"  # Your repo

# List of files to exclude
EXCLUDE_FILES=(
    ".gitignore"
    "sync-with-merge.sh"
    "sync-with-overwrite.sh"
    "README.md"
)

# Ask for user confirmation
read -p "This will overwrite all local changes. Do you want to continue? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Operation cancelled."
    exit 1
fi

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

# Step 2: Copy files to extracted repo but exclude some files
cd "$EXTRACTED_REPO_PATH"

# Backup excluded files
for FILE in "${EXCLUDE_FILES[@]}"; do
    [ -f "$FILE" ] && cp "$FILE" "/tmp/$FILE.bak"
done

# Remove old files
git rm -r --quiet . 2>/dev/null || true

# Copy new files from monorepo
cp -r "$MONOREPO_PATH/$MONOREPO_SUBFOLDER/." "$EXTRACTED_REPO_PATH/"

# Restore excluded files
for FILE in "${EXCLUDE_FILES[@]}"; do
    [ -f "/tmp/$FILE.bak" ] && mv "/tmp/$FILE.bak" "$FILE"
done

# Step 3: Commit & push changes
git add .
read -p "Do you want to commit changes to main? (y/n): " COMMIT_CONFIRM
if [[ "$COMMIT_CONFIRM" == "y" ]]; then
    git commit -m "Overwritten with latest monorepo changes (excluding specific files) on $(date)"
    git push origin main --force  # Adjust branch if necessary
    echo "Changes committed and pushed to main."
else
    echo "Changes not committed."
fi

echo "Sync complete! Excluded files were preserved."
