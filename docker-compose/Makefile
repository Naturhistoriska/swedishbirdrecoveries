#! make

all-up:
	docker-compose -f docker-compose.all.yml up

test-up:
	docker-compose -f docker-compose.test.yml up -d shiny

test-ps:
	docker-compose -f docker-compose.test.yml ps

test-logs:
	docker-compose -f docker-compose.test.yml logs -f

test-down:
	docker-compose -f docker-compose.test.yml down --remove-orphans


# if conflict then 'docker rm xyzxx'