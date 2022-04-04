#!/usr/bin/env python3

# Influenced By ... https://unix.stackexchange.com/questions/222368/get-date-of-next-saturday-from-a-given-date

import arrow
import sys

# >>> [ arrow.get(f"2020-07-{x:02d}").strftime("%A") for x in range(6,6+7)]
VALID_DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

def main(date, day_of_week):
	d = arrow.get(date)
	while day_of_week != d.strftime("%A"):
		d = d.shift(days=1)
	return str(d)

if __name__ == "__main__":
	print(main(sys.argv[1],sys.argv[2])[:10])
	
