#!/usr/bin/env bash

echo "Your are currently acting as $(aws sts get-caller-identity --output text | cut -f 2 | cut -d":" -f 6)."
