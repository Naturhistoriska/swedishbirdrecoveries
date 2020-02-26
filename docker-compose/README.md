# Pre-requirements.

production machine = nrmbirdringing.nrm.se  <p>

0. Operating system : Ubuntu 18.04.4 LTS
1. 'make' version (`make -v`): tested with = GNU Make 4.1
2. 'docker' version (`docker -v`) : tested with version 18.09.7
3. 'docker-compose' version (`docker-compose -v`) Tested with version 1.22.0

***

# cron

[Information on cron](https://en.wikipedia.org/wiki/Cron)

1. `service crond status`
2. `service crond stop`
3. `service crond start`
4. check the logs -> `grep cron /var/log/syslog`


## Every morning at 04:00

1. bin/refresh-swedishbirdrecoveries.sh
2. run by cron : `0 4 * * * ~/bin/refresh-swedishbirdrecoveries.sh >> ~/bin/refresh-swedishbirdrecoveries.log 2>&1`


## @reboot 

2020-02-26; on the old-machine (bioatlas machine)  <p>
1. @reboot sleep 60 && su gbif -l -c "cd repos/ala-docker && make up && make up 

2020-02-xx; now on the nrmbirdringing machine (now user 'ingierli') <p>
1. @reboot sleep 60 && su ingierli -l -c "cd repo/swedishbirdrecoveries/docker-compose && make up 
[ ] Test: reboot the machine, service starts


# Observe : URL to fagel3.nrm.se is hardcoded

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L23 

## 2020-01-25 
if the file at fagel3.nrm.se cannot be reached then an old sqlite database is used <br>
see here 

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L91-L101
