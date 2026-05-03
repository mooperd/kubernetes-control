# kube-select

A TUI for selecting and connecting to GKE clusters across all your GCP projects, with shell prompt integration so you always know which cluster you're on.

## Prerequisites

| Tool | Install |
|------|---------|
| `gcloud` CLI | `brew install --cask google-cloud-sdk` |
| `kubectl` | `brew install kubectl` |
| `gke-gcloud-auth-plugin` | `gcloud components install gke-gcloud-auth-plugin` |
| `fzf` *(optional, recommended)* | `brew install fzf` |

Make sure you're authenticated:

```bash
gcloud auth login
```

## Installation

```bash
# Make the script executable
chmod +x kube-select

# Symlink into your PATH (optional)
ln -s "$(pwd)/kube-select" /usr/local/bin/kube-select
```

## Usage

### Interactive cluster selection

```
kube-select
```

Walks you through:
1. **Pick a GCP project** from all projects you have access to
2. **Pick a GKE cluster** within that project (shows location, status, node count)
3. **Connects** — configures `kubectl` credentials automatically

### Quick-switch between known contexts

```
kube-select switch
```

Lists all contexts already in your `~/.kube/config` and lets you switch instantly.

### Show current cluster

```
kube-select current
```

## Shell prompt integration

Add to your `~/.zshrc` (or `~/.bashrc`):

```bash
source "/path/to/kube-prompt.sh"
```

Your prompt will show the active cluster, project, region, and namespace:

```
☸ my-cluster (my-project/europe-west2)/default ~/code $
```

The prompt updates automatically whenever you switch contexts.

## How it works

- Uses `gcloud projects list` to enumerate all projects your account can access
- Uses `gcloud container clusters list` to find GKE clusters in a project
- Uses `gcloud container clusters get-credentials` to configure `kubectl`
- If `fzf` is installed, provides a fuzzy-search TUI; otherwise falls back to a numbered menu
