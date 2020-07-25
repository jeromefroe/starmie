#!/usr/bin/env bash

set -euo pipefail

EXT="star"
CLUSTERS=$(find envs -type d -depth 1 -print0 | xargs -0 -n1 basename)

for CLUSTER in $CLUSTERS; do
  NAMESPACES=$(find envs/"$CLUSTER" -type f -print0 | xargs -0 -I{} basename {} ".$EXT" | grep -v base)
  for NAMESPACE in $NAMESPACES; do
    starlark -recursion -showenv "envs/$CLUSTER/$NAMESPACE.$EXT" 2>&1 |
      grep "^config =" |
      grep -oE '{.*}' |
      sed 's/: None/: null/g' |
      yq r --prettyPrint - >"gen/${CLUSTER}_${NAMESPACE}.yaml"
  done
done
