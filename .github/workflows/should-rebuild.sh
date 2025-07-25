#!/bin/sh

git diff HEAD~1 --quiet -- "$UBUNTU_DOCKERFILE"
if [ $? -eq 1 ]; then
    msrv=$(awk '/^.*rust-version = "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+"$/ \
    { print substr($NF, 2, length($NF) - 2) }' "$ROOT_CARGO_TOML");
else
    msrv=$(git diff HEAD~1 --output-indicator-new=+ -- "$ROOT_CARGO_TOML" |
    awk '/^+.*rust-version = "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+"$/ \
    { print substr($NF, 2, length($NF) - 2) }');
fi

if [ -z "$msrv" ]; then
    echo "should-build=false" >> "$GITHUB_OUTPUT";
    exit 1;
fi

echo "should-build=true" >> "$GITHUB_OUTPUT";
echo "msrv=$msrv" >> "$GITHUB_OUTPUT";
