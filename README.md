ICDM2016 DM649
===============

Algorithm Working Environment
--------

- Matlab R2015b or later
- YALMIP Release 20150918 or later
- Cplex v12.6

Data
--------
- Taxi_1046581.csv:

This is a sample taxi trajectory on 2014-12-11, each column of attributes are: {ID, longitude, latitude, time(yyyy-mm-dd hh:mm:ss), passenger load indicator(1 means having load passenger(s), otherwise, 0)}


- allSeekEvents.csv:

This is one day taxi seeking events. The column of attributes are the same than '1046581.csv'


- bilevel_output.csv:

There are 57*27 numbers in the file, each number indicates the number of EV chargers should be built in the area, which is match with the map file(html).


- demand.csv:

There are 57*27 numbers in the file, each number indicates the number of average refilling demand in 24 hours in the area, which is match with the map file(html).


- parking_time.csv:

There are 57*27 numbers in the file, each number indicates the number of average parking time in the area, which is match with the map file(html).


- usability.csv:

There are 57*27 numbers in the file, each number indicates the number of travelling time for seek a EV charger in the area, which is match with the map file(html).


Algorithm
--------

- Alternating Method for Bilevel Programming - bilevel_alternating.m

How to use
--------

- Algorithm:

1. Install Cplex v12.6 running environment
2. Install matlab R2015b and download YALMIP tool box
3. Import YALMIP and Cplex as tool box to matlab
4. Import the algorithm file(bilevel_alternating.m) and data file in the same path.
5. Run the algorithm file in matlab.

* The algorithm may take a while to generate result, you can modify the number of row(m) and column(n) to get a result in a smaller area.

- Data Presentation:

Put the *.html file and data file in the same path, then you can open the webpage with your browser.



