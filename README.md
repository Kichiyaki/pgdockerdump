It's a very simple bash script that helps you download Postgres dumps from a remote server.

## How to use it

**Remember that you have to add your SSH Public Key on the target server!**

1. Download this bash script.
```bash
curl -fsSL https://raw.githubusercontent.com/Kichiyaki/pgdockerdump/master/pgdockerdump.sh -o pgdockerdump.sh
```
2. Create a new script using vim/nano/whatever else and paste the code below (replace user, ip, container_name, db_user, db_name with your credentials):
```bash
#!/bin/bash

source pgdockerdump.sh user@ip

#7 days
sub="$((60 * 60 * 24 * 7))"

downloadDump container_name db_user db_name
deleteOldDumps db_name "$sub"
```
