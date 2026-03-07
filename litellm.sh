mkdir ~/.litellm
cd ~/.litellm
cp ~/API_KEY.sh .env
curl -O https://raw.githubusercontent.com/BerriAI/litellm/refs/heads/main/prometheus.yml
touch config.yaml
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml
sed -i -e 's/5432/5433/g' -e '/volumes:/s/# //' -e '/- \.\/config.yaml:\/app\/config.yaml/s/#//' -e '/command:/s/# //' -e '/- "--config=\/app\/config.yaml"/s/#//' docker-compose.yml
docker compose up
