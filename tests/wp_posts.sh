#!/bin/bash

set -eu

echo "Creating a few posts"

for type in press publication story; do
  wp post generate \
    --count=3 \
    --format=ids \
    --post_author=test_user \
    | xargs -d ' ' -I % sh -c "
      wp post term add % p4-page-type $type &&
      wp post term add % post_tag Oceans
    "
done