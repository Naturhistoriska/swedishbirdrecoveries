# Pre-requirements.

0. Operating system : Ubuntu 18.04.4 LTS
1. 'make' version (`make -v`): tested with = GNU Make 4.1
2. 'docker' version (`docker -v`) : tested with version 18.09.7
3. 'docker-compose' version (`docker-compose -v`) Tested with version 1.22.0

***

# Script fetching data 

1. bin/refresh-swedishbirdrecoveries.sh
2. run by cron : `0 4 * * * ~/bin/refresh-swedishbirdrecoveries.sh >> ~/bin/refresh-swedishbirdrecoveries.log 2>&1`

[Information on cron](https://en.wikipedia.org/wiki/Cron)

## Observe : URL to fagel3.nrm.se is hardcoded

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L23 

### 2020-01-25 
if the file at fagel3.nrm.se cannot be reached then an old sqlite database is used <br>
see here 

https://github.com/naturhistoriska/swedishbirdrecoveries/blob/master/R/update.R#L91-L101
