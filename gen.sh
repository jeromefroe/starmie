#!/usr/bin/env bash

set -euo pipefail

CLUSTERS=$(find envs -type d -depth 1 -print0 | xargs -0 -n1 basename)

for CLUSTER in $CLUSTERS; do
  NAMESPACES=$(find "envs/$CLUSTER" -type d -depth 1 -print0 | xargs -0 -I{} basename {})
  for NAMESPACE in $NAMESPACES; do
    starlark -recursion -float "envs/$CLUSTER/$NAMESPACE/module.star" 2>&1 |
      sed 's/: None/: null/g' |
      yq r --prettyPrint - >"gen/${CLUSTER}_${NAMESPACE}.yaml"
  done
done
