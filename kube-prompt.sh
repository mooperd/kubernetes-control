#!/usr/bin/env zsh
# kube-prompt.sh — Show current Kubernetes cluster & namespace in your shell prompt.
# Source in ~/.zshrc:  source "/path/to/kube-prompt.sh"

__kube_ps1() {
  local ctx
  ctx=$(kubectl config current-context 2>/dev/null) || return
  [[ -z "$ctx" ]] && return

  local ns
  ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
  ns="${ns:-default}"

  # GKE format: gke_PROJECT_REGION_CLUSTER → cluster (project/region)
  local label
  if [[ "$ctx" =~ '^gke_(.+)_([a-z]+-[a-z]+[0-9](-[a-z])?)_(.+)$' ]]; then
    label="${match[4]} (${match[1]}/${match[2]})"
  else
    label="$ctx"
  fi

  print -n "%F{yellow}☸ ${label}%F{cyan}/${ns}%f"
}

setopt PROMPT_SUBST
[[ "$PROMPT" != *'$(__kube_ps1)'* ]] && PROMPT='$(__kube_ps1) '"$PROMPT"
