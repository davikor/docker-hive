# Getting HIVE up and running

## Starting services

> `docker-compose up -d`

> `docker-compose up -d presto-coordinator`

## Loading data

Login onto hive-server
> `docker-compose exec hive-server bash`

Connect with beeline cli to hive
> `/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000`

create and fill table
> `CREATE TABLE pokes (foo INT, bar STRING);`

> `LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;`

## Execute MatchPath queries

Examples can be found in Hive-Unittests, e.g. [here](https://github.com/apache/hive/blob/master/ql/src/test/queries/clientpositive/ptf_matchpath.q), [here](https://github.com/apache/hive/blob/master/itests/hive-blobstore/src/test/queries/clientpositive/ptf_matchpath.q) and [here](https://github.com/apache/hive/blob/master/ql/src/test/queries/clientpositive/ptf_register_tblfn.q).

Example

`select origin_city_name, fl_num, year, month, day_of_month, sz
from matchpath(on 
        flights_tiny 
        distribute by fl_num 
        sort by year, month, day_of_month
        arg1('EARLY+.LATE'), 
        arg2('LATE'), 
        arg3(arr_delay > 15), 
        arg4('EARLY'), 
        arg5(arr_delay < -15), 
        arg6('origin_city_name, fl_num, year, month, day_of_month, size(tpath) as sz, tpath') 
   );`