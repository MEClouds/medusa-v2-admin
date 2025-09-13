# Medusa Admin Dashboard

This is a separate admin dashboard for Medusa v2. It has been extracted from the [Medusa repository](https://github.com/medusajs/medusa/tree/develop/packages/admin) to facilitate easier customization and development.

## Compatibility

This dashboard is compatible with Medusa v2.10.2

## Prerequisites

- A running instance of Medusa v2.10.2

## Getting Started

1. Clone the repository:

```sh
  git clone https://github.com/MEClouds/medusa-v2-admin.git
```

2. Install dependencies:

```sh
  yarn install
```

3. Start the development server:

```sh
  yarn dev
```

To sync the latest changes from the original repository, you have two options:

1. Sync with merge:

```sh
  chmod +x sync-with-merge.sh
  ./sync-with-merge.sh
```

This option will merge the latest changes from the original repository into your local repository, preserving your local changes.

2. Sync with overwrite:

```sh
  chmod +x sync-with-overwrite.sh
  ./sync-with-overwrite.sh
```

**Warning:** This option will overwrite all your local changes with the latest changes from the original repository. Make sure to back up any important local changes before using this option.
