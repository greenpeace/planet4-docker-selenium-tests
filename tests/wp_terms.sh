#!/bin/bash

set -eu

function ensure_term() {
  local taxonomy="$1"; shift;
  local term="$1"; shift;
  local create_options="$@"
  wp term get "$taxonomy" "$term" --by=slug --field=id || \
    wp term create "$taxonomy" "$term" $create_options --porcelain;
}

echo "Creating tags"
ensure_term "post_tag" "ArcticSunrise" --user=admin
ensure_term "post_tag" "Oceans" --user=admin

echo "Creating categories"
parent=$(ensure_term "category" "issues")
ensure_term "category" "energy" --parent="$parent"
ensure_term "category" "nature" --parent="$parent"
ensure_term "category" "people" --parent="$parent"

echo "Create p4 page types"
ensure_term "p4-page-type" "press"
ensure_term "p4-page-type" "publication"
ensure_term "p4-page-type" "story"

# Give them nicer display names
wp term update --by=slug "p4-page-type" "press" --name="Press Release"
wp term update --by=slug "p4-page-type" "publication" --name="Publication"
wp term update --by=slug "p4-page-type" "story" --name="Story"