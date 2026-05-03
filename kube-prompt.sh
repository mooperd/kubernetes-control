#!/usr/bin/env bash
# kube-prompt.sh — Show current Kubernetes cluster & namespace in your shell prompt.
# Source this file in ~/.zshrc or ~/.bashrc:
#   source "/path/to/kube-prompt.sh"

# Returns a short, readable cluster label from the full context name.
# e.g. "gke_my-project_europe-west2_my-cluster" → "my-cluster (my-project/europe-west2)"
__kube_label() {
  local ctx="$1"
  # GKE format: gke_PROJECT_REGION_CLUSTER
  if [[ "$ctx" =~ ^gke_(.+)_([a-z]+-[a-z]+[0-9](-[a-z])?)_(.+)$ ]]; then
    local project="${BASH_REMATCH[1]}"
    local region="${BASH_REMATCH[2]}"
    local cluster="${BASH_REMATCH[4]}"
    printf '%s (%s/%s)' "$cluster" "$project" "$region"
  else
    printf '%s' "$ctx"
  fi
}

# Generates the prompt segment.  Called each time the prompt renders.
__kube_ps1() {
  local ctx
  ctx=$(kubectl config current-context 2>/dev/null) || return
  [[ -z "$ctx" ]] && return

  local ns
  ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  ns="${ns:-default}"

  local label
  label=$(__kube_label "$ctx")

  # Color: green when connected, red placeholder if empty
  printf '\033[0;33m☸ %s\033[0;36m/%s\033[0m' "$label" "$ns"
}

# ── Zsh integration ─────────────────────────────────────────────────────────
if [[ -n "${ZSH_VERSION:-}" ]]; then
  setopt PROMPT_SUBST
  # Prepend kube info to existing prompt
  if [[ "$PROMPT" != *'$(__kube_ps1)'* ]]; then
    PROMPT='$(__kube_ps1) '"$PROMPT"
  fi
# ── Bash integration ────────────────────────────────────────────────────────
elif [[ -n "${BASH_VERSION:-}" ]]; then
  if [[ "$PS1" != *'$(__kube_ps1)'* ]]; then
    PS1='$(__kube_ps1) '"$PS1"
  fi
fi
