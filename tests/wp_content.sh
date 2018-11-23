#!/bin/bash

set -eu

function find_or_create_page() {
  local name=$1; shift
  local title=$1; shift
  local category=$1; shift
  local create_options="$@"

  id=$(wp post list --post_type=page --name="$name" --format=ids)
  if [[ -z "$id" ]]; then
    id=$(wp post create \
      --post_name="$name" \
      --post_title="$title" \
      --post_category="$category" \
      --post_type=page \
      --post_author=test_user \
      --post_status=publish \
      $create_options \
      --porcelain)
  fi
  echo "$id"
}

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

# The act pages are needed for the covers test

echo "Creating an Act page"

act_page=$(find_or_create_page "act" "Act" "energy")

echo "Creating some Act subpages"

find_or_create_page "actsubpage1" "Act Subpage 1" "energy" --post_parent="$act_page" --tags_input="Oceans"
find_or_create_page "actsubpage2" "Act Subpage 2" "nature" --post_parent="$act_page" --tags_input="ArcticSunrise"
find_or_create_page "actsubpage3" "Act Subpage 3" "people" --post_parent="$act_page" --tags_input="ArcticSunrise"

wp option patch insert planet4_options act_page "$act_page";