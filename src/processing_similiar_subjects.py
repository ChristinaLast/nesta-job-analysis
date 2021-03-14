import csv
import math
from collections import Counter

with open("data/lookupTable.csv", "r") as f:
    reader = csv.reader(f)
    inputArray = list(reader)

count = 0
newList = []
for item in inputArray:
    item = list(filter(None, item))

    i = map(int, item)
    i = sorted(i)
    newList.append(" ".join([str(x) for x in i]))

q = dict(Counter(newList))

with open("visualisation/data/lookupTable-circles.csv", "w") as f:
    writer = csv.writer(f)
    for i in newList:
        temp = [math.log(q[i])] + i.split()
        writer.writerow(temp)
