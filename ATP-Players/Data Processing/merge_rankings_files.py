# -*- coding: utf-8 -*-
"""
Created on Mon Jun  4 18:27:01 2018

@author: franklin
"""
#Merge all rankings files
fout=open("../Data/mergedrankings.csv","a")
# Get headers
headers = open("../Data/4_rankings/rankings_column_titles.txt")
headerItems = headers.read().split('\n')
headerRow = headerItems[0]
#headerRow = ""
for item in headerItems:
    headerRow = headerRow+','+item
    #headerRow = headerRow+item+','
fout.write(headerRow)
fout.write('\n')
# Add files   
print(headerRow)
for num in range(1973,2018):
    f = open("../Data/4_rankings/rankings_"+str(num)+".csv")
    for line in f:
         fout.write(line)
    f.close() 

fout.close()
