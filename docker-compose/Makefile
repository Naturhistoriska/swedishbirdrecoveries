#! make

up: local-up 

logs: local-logs

local-up:
	docker-compose -f docker-compose.local.yml up -d 

local-logs:
	docker-compose -f docker-compose.local.yml logs -f

test-up:
	docker-compose -f docker-compose.test.yml up -d 

test-ps:
	docker-compose -f docker-compose.test.yml ps

test-logs:
	docker-compose -f docker-compose.test.yml logs -f

test-down:
	docker-compose -f docker-compose.test.yml down --remove-orphans




# NOTE: if conflict then 'docker rm xyzxx'