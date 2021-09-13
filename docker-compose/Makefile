#! make

up: local-up

logs: local-logs

local-up:
	docker-compose -f docker-compose.local.yml up -d
local-ps:
	docker-compose -f docker-compose.local.yml ps

local-logs:
	docker-compose -f docker-compose.local.yml logs -f

local-down:
	docker-compose -f docker-compose.local.yml down --remove-orphans


test-up:
	docker-compose -f docker-compose.test.yml up -d

test-ps:
	docker-compose -f docker-compose.test.yml ps

test-logs:
	docker-compose -f docker-compose.test.yml logs -f

test-down:
	docker-compose -f docker-compose.test.yml down --remove-orphans




# NOTE: if conflict then 'docker rm xyzxx'
