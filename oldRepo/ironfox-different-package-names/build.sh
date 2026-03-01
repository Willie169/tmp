#!/usr/bin/env bash

set -exo pipefail
git clone https://gitlab.com/ironfox-oss/IronFox.git
cd IronFox
tag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
git checkout "$tag"
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
sed -Ezi 's/\n[ \t]*read -p '"'"'Do you want to continue \[y\/N\] '"'"' -n 1 -r\n[ \t]*echo '"''"'\n[ \t]*if ! \[\[ "\$\{REPLY\}" =~ \^\[Yy\]\$ \]\]; then\n[ \t]*echo_red_text '"'"'Aborting\.\.\.'"'"'\n[ \t]*exit 1\n[ \t]*fi//' scripts/build-if.sh
git add scripts/build-if.sh
GIT_AUTHOR_DATE="$(git show -s --format=%aI HEAD)" GIT_COMMITTER_DATE="$(git show -s --format=%cI HEAD)" git commit -m patch
./scripts/get_sources.sh
./scripts/prebuild.sh
./scripts/build.sh arm64
env
tree
cd
tree
