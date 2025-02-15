#!/bin/bash

# Define variables
MONOREPO_URL="https://github.com/medusajs/medusa.git"
MONOREPO_BRANCH="develop"
MONOREPO_SUBFOLDER="packages/admin/dashboard"
EXTRACTED_REPO_PATH="$(pwd)"  # Your repo

# Step 1: Add monorepo as a remote (only once)
git remote add monorepo "$MONOREPO_URL" 2>/dev/null || true

# Step 2: Fetch the latest changes from the monorepo
git fetch monorepo "$MONOREPO_BRANCH"

# Step 3: Merge updates (preserve local modifications)
git merge --no-commit --no-ff monorepo/"$MONOREPO_BRANCH"

# Step 4: Handle conflicts manually if needed
echo "Merge complete. Resolve conflicts if necessary, then commit."

# Step 5: Commit & push changes (if any)
if ! git diff --quiet; then
    read -p "Do you want to commit changes and push to main? (y/n): " choice
    if [[ "$choice" == [Yy]* ]]; then
        git add .
        git commit -m "Merged latest changes from monorepo on $(date)"
        git push origin main  # Adjust branch if necessary
        echo "Changes pushed!"
    else
        echo "Changes not pushed."
    fi
else
    echo "No new changes to commit."
fi
else
    echo "No new changes to commit."
fi

echo "Sync complete!"
