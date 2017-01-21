# Grab data from NFL Game Center using nflgame package
# Outputs csv files for each player per game per season.
# Written by LC 12/07/16 for use in NFlSearch! Project.

import nflgame
import time
import csv
import pandas as pd
import time
import re

for year in range(2009,2010):
    
    print "Collecting data from " + str(year) + "..." 
    filename = 'players_season' + str(year) + '.csv'
    f = open(filename, 'w')
    weeks = 17
    lines = []  # init holder of all player stat lines to sort
    running_length = 0  # line counter for adding the correct week to the proper lines

    # there are 17 weeks in an NFL season, each player can have max 16 stat lines due to bye week
    for week in range(1,weeks + 1): 
        # combine_max_stats sums stats over weeks, so we do one week at a time
        # we choose to do this because combine_max_stats gives us more stat categories than other methods
        nflgame.combine_max_stats(nflgame.games(year,[week])).csv('temp.csv', allfields = True) 

        # no way to include append in nflgame .csv method, so we do it in a roundabout fashion
        with open('temp.csv', 'rb') as k:
            current_lines = k.readlines()


        lines.extend(current_lines)

        for m in range(running_length + 1, len(lines)):  # ignore first line, which will be header
            
            w = str(week)
            lines[m] = lines[m].rstrip() + ',' + w + '\n'

        running_length += len(current_lines)



    # sorts by name, the first value in stat line. 
    # Weeks are not in order. Difficult to sort now because it is a string.
    lines.sort()

    header = lines.pop()
    header = header.rstrip() + ',week\n'
    f.write(header)

    

    # because there are 16 (1 per week) extra headers which are sorted to the bottom of the list
    for line in lines[:-weeks + 1]:
        f.write(line)

    with open('headers.csv', 'wb') as k:
        for line in lines[-weeks +1 :-1]:
            k.write(line)

    # cleanup
    del lines
    f.close()


