#! make

test-up:
	docker-compose -f docker-compose.test.yml up -d 

test-ps:
	docker-compose -f docker-compose.test.yml ps

test-logs:
	docker-compose -f docker-compose.test.yml logs -f

test-down:
	docker-compose -f docker-compose.test.yml down --remove-orphans


# NOTE: if conflict then 'docker rm xyzxx'