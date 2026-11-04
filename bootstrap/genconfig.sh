#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="$(dirname "$(realpath "$0")")"
OUTPUT_DIR="$BASE_DIR/generated"

# renovate: packageName=siderolabs/talos datasource=github-releases
TALOS_VERSION="v1.13.12"

# renovate: packageName=siderolabs/kubelet datasource=github-releases
KUBERNETES_VERSION="v1.36.5"

# get schematic id from talos image factory
SCHEMATIC_ID=$(curl -fsS --data-binary @"$BASE_DIR/schematic.yaml" https://factory.talos.dev/schematics | jq -r .id)

# decrypt secrets file
sops -d "$BASE_DIR/secrets.sops.yaml" > "$OUTPUT_DIR/secrets.yaml"

mise exec -- talosctl gen config lab "https://192.168.1.30:6443" \
    --with-secrets "$OUTPUT_DIR/secrets.yaml" \
    --talos-version "$TALOS_VERSION" \
    --kubernetes-version "$KUBERNETES_VERSION" \
    --install-image "factory.talos.dev/metal-installer/$SCHEMATIC_ID:$TALOS_VERSION" \
    --install-disk /dev/nvme0n1 \
    --output-types controlplane,talosconfig \
    --output "$OUTPUT_DIR" \
    --with-docs=false \
    --with-examples=false \
    --force \
    --config-patch @"$BASE_DIR/config.yaml"
