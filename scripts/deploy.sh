#!/usr/bin/env bash
set -euo pipefail

RELEASE_NAME=${1:-mediawiki}
NAMESPACE=${2:-mediawiki}
VALUES_FILE=${3:-helm/mediawiki/values.yaml}

helm upgrade --install "$RELEASE_NAME" ./helm/mediawiki \
  --namespace "$NAMESPACE" \
  --create-namespace \
  -f "$VALUES_FILE"
