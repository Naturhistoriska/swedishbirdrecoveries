# pre-requirements.

<p>

0. Operating system : Ubuntu 18.04.4 LTS
1. 'make' version (`make -v`): tested with = GNU Make 4.1
2. 'docker' version (`docker -v`) : tested with version 18.09.7
3. 'docker-compose' version (`docker-compose -v`) Tested with version 1.22.0

<p>
  
**Production machine** <p>
  
0. production machine = nrmbirdringing.nrm.se  
1. URL is set in the docker-compose.prod.yml file (birdrecoveries.nrm.se)
2. Proxy handles the certs (see the 'cert'-folder)
3. Shiny-Application and Proxy are in  the same compose-file (docker-compose.prod.yml) 

<p>
  
**Stage machine** <p>
  
0. stage machine = Digital Ocean machine 
1. URL is set in the docker-compose.stage.yml file (birdrecoveries.dina-system.org)
2. Proxy handles the certs (NO certs available for 'dina-system.org' and that is ok)
3. Proxy is running in its own compose-file, the Shiny-Application needs to point to the correct Network

<p>
  
**Test machine** <p>
  
0. stage machine = your local machine
1. URL is set in the docker-compose.test.yml file (test.nrm.se) - update your /etc/hosts
2. Proxy handles the certs (NO Need for cert)
3. Shiny-Application and Proxy are in  the same compose-file (docker-compose.test.yml)

***

# cron and scheduled cron jobs

[Information on cron](https://en.wikipedia.org/wiki/Cron)

1. `service crond status`
2. `service crond stop`
3. `service crond start`
4. check the logs -> `grep cron /var/log/syslog`

## [Production-machine] crontab -l for root 

login is as root and run  `crontab -l`

1. `0 4 * * * cd /home/ingierli/repos/swedishbirdrecoveries/docker-compose/bin && ./refresh-swedishbirdrecoveries.sh >> ./refresh-swedishbirdrecoveries.log 2>&1`
2.  `@reboot sleep 60 && su ingierli -l -c "cd repos/swedishbirdrecoveries/docker-compose && make up`


### Every morning at 04:00

**1** Runs the refresh-script, fetches data (csv) from fagel3.nrm.se 


### @reboot 

**2** from the specified directory, runs `make up`



# fagel3.nrm.se

## flow from the database, to the csv-file

WIP

1. time 22:30; csv-file from the database is generated every evening 
2. time 00:00; timestamp on  the 'aterfynd'-directory 


Observe : URL to fagel3.nrm.se is hardcoded in one of the R-classes

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L23 

## 2020-01-25 
if the file at fagel3.nrm.se cannot be reached then an old sqlite database is used <br>
see here 

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L91-L101

# Running locally

step-by-step. <p>
change the url in the docker-compose.test.yml to birdringing-test.nrm.se <p>
update the file /etc/hosts with (127.0.0.1 birdringing-test.nrm.se)

1. xx
2. yy
3. zz
