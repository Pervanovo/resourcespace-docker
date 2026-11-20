build:
	docker compose build
fresh:
	docker compose build --no-cache
shell:
	docker compose run resourcespace ash
versions:
	docker run --rm resourcespace-docker-resourcespace apk list --installed | grep -E '^(apache2|zlib|openssl|musl)-'