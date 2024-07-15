.PHONY: up
up:
	@docker-compose -f docker/docker-compose.yml up -d

.PHONY: down
down:
	@docker compose -f docker/docker-compose.yml down

.PHONY: follow-pgsync-logs
follow-pgsync-logs:
	@docker compose -f docker/docker-compose.yml logs pgsync --follow

.PHONY: build
build:
	@docker compose -f docker/docker-compose.yml build