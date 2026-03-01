docker run --rm registry.gitlab.com/ironfox-oss/ironfox:latest bash <<'4e22b312-4626-4d4a-9126-a4c0bf6f204d'
git clone https://gitlab.com/ironfox-oss/IronFox.git
cd IronFox
git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
./scripts/get_sources.sh
./scripts/prebuild.sh
./scripts/build.sh arm64
4e22b312-4626-4d4a-9126-a4c0bf6f204d
