#!/usr/bin/env bash

wget "$(curl -fsSL https://gitlab.com/api/v4/projects/65779408/releases/permalink/latest | jq -r --arg U universal '.assets.links | map(select(.name | test($U))) | .[0].direct_asset_url')"
