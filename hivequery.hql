create table flights_tiny ( 
ORIGIN_CITY_NAME string, 
DEST_CITY_NAME string, 
YEAR int, 
MONTH int, 
DAY_OF_MONTH int, 
ARR_DELAY float, 
FL_NUM string 
);

LOAD DATA LOCAL INPATH '/opt/hive/examples/files/flights_tiny.txt' OVERWRITE INTO TABLE flights_tiny;

select * from flights_tiny where fl_num=2646 order by year, month, day_of_month;

select tf.* from (select 0) t lateral view explode(array('A','B','C')) tf as col;

--explain
select fl_num,tpath.item.year
--select origin_city_name, fl_num, year, month, day_of_month, sz
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
   );


select tf.*
from matchpath(on 
        flights_tiny 
        distribute by fl_num 
        sort by year, month, day_of_month
        arg1('EARLY+.LATE'), 
        arg2('LATE'), 
        arg3(arr_delay > 15), 
        arg4('EARLY'), 
        arg5(arr_delay < -15), 
        arg6('tpath') 
   ) lateral view explode(tpath.year) tf as col;