mkdir ~/.litellm
cd ~/.litellm
cat ~/API_KEY.sh | grep LITELLM_MASTER_KEY > .env
cat ~/API_KEY.sh | grep LITELLM_SALT_KEY >> .env
cat ~/API_KEY.sh | grep OPENAI_API_KEY >> .env
cat ~/API_KEY.sh | grep ANTHROPIC_API_KEY >> .env
cat ~/API_KEY.sh | grep GEMINI_API_KEY >> .env
cat ~/API_KEY.sh | grep DEEPSEEK_API_KEY >> .env
cat ~/API_KEY.sh | grep OPENROUTER_API_KEY >> .env
cat ~/API_KEY.sh | grep MISTRAL_API_KEY >> .env
source .env
curl -O https://raw.githubusercontent.com/BerriAI/litellm/refs/heads/main/prometheus.yml
cat > docker-compose.yml <<'EOF'
services:
  litellm:
    build:
      context: .
      args:
        target: runtime
    image: docker.litellm.ai/berriai/litellm:main-stable
    volumes:
      - ./config.yaml:/app/config.yaml
    command:
      - "--config=/app/config.yaml"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    ports:
      - "4000:4000" # Map the container port to the host, change the host port if necessary
    environment:
      DATABASE_URL: "postgresql://llmproxy:dbpassword9090@db:5432/litellm"
      STORE_MODEL_IN_DB: "True" # allows adding models to proxy via UI
    env_file:
      - .env # Load local .env file
    depends_on:
      - db  # Indicates that this service depends on the 'db' service, ensuring 'db' starts first
    healthcheck:  # Defines the health check configuration for the container
      test:
        - CMD-SHELL
        - python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:4000/health/liveliness')"  # Command to execute for health check
      interval: 30s  # Perform health check every 30 seconds
      timeout: 10s   # Health check command times out after 10 seconds
      retries: 3     # Retry up to 3 times if health check fails
      start_period: 40s  # Wait 40 seconds after container start before beginning health checks

  db:
    image: postgres:16
    restart: always
    container_name: litellm_db
    environment:
      POSTGRES_DB: litellm
      POSTGRES_USER: llmproxy
      POSTGRES_PASSWORD: dbpassword9090
    volumes:
      - postgres_data:/var/lib/postgresql/data # Persists Postgres data across container restarts
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -d litellm -U llmproxy"]
      interval: 1s
      timeout: 5s
      retries: 10

  prometheus:
    image: prom/prometheus
    volumes:
      - prometheus_data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--storage.tsdb.retention.time=15d"
    restart: always

volumes:
  prometheus_data:
    driver: local
  postgres_data:
    name: litellm_postgres_data # Named volume for Postgres data persistence
EOF
cat > ~/.litellm/config.yaml <<'EOF'
environment_variables:
    LITELLM_SALT_KEY: os.environ/LITELLM_SALT_KEY

model_list:
    - model_name: openai/*
      litellm_params:
        model: openai/*
        api_key: os.environ/OPENAI_API_KEY
    - model_name: anthropic/*
      litellm_params:
        model: anthropic/*
        api_key: os.environ/ANTHROPIC_API_KEY
    - model_name: gemini/*
      litellm_params:
        model: gemini/*
        api_key: os.environ/GEMINI_API_KEY
    - model_name: deepseek/*
      litellm_params:
        model: deepseek/*
        api_key: os.environ/DEEPSEEK_API_KEY
    - model_name: openrouter/*
      litellm_params:
        model: openrouter/*
        api_key: os.environ/OPENROUTER_API_KEY
    - model_name: mistral/*
      litellm_params:
        model: mistral/*
        api_key: os.environ/MISTRAL_API_KEY

litellm_settings:
    check_provider_endpoint: true

general_settings: 
    master_key: os.environ/LITELLM_MASTER_KEY
EOF
docker compose up -d
curl 'http://localhost:4000/models?return_wildcard_routes=false&include_model_access_groups=false&only_model_access_groups=false&include_metadata=false' \
-H "Authorization: Bearer $LITELLM_MASTER_KEY" \
-H "Content-Type: application/json"
curl http://localhost:4000/v1/chat/completions \
-H "Authorization: Bearer $LITELLM_MASTER_KEY" \
-H "Content-Type: application/json" \
-d '{
  "model": "openrouter/openrouter/free",
  "messages": [
    {"role":"user","content":"Hello"}
  ]
}'
