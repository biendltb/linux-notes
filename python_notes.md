
### datetime and timezone
Problem: get a string of time in a local time zone, convert to UTC time
```python
from datetime import datetime
import pytz

date_format = '%Y-%m-%d %H:%M:%S'
time_str = '2021-08-18 10:35:06'
# local time zone obj
london_tz = pytz.timezone('Europe/London')
# parse time
time_obj = datetime.strptime(start_time_str, date_format)
# set time zone
time_obj_with_tz = london_tz.localize(time_obj)
# convert time to UTC time
time_obj_utc = time_obj_with_tz.astimezone(pytz.utc)
```
