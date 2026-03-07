mkdir ~/.litellm
cd ~/.litellm
cp ~/API_KEY.sh .env
chmod -x .env
curl -O https://raw.githubusercontent.com/BerriAI/litellm/refs/heads/main/prometheus.yml
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml
sed -i -e 's/5432/5433/g' -e 's/5433:5433/5433:5432/g' docker-compose.yml
docker compose up -d
