# Checks length of each row matches number of columns
from sys import argv


filename = argv[1]
delimiter = argv[2]

row_length = []

with open(filename, 'rb') as f:
    lines = f.readlines()
    ncol = len(lines[0].split(delimiter))
    for line in lines:
        # do a generator?
        k = line.split(delimiter)
        row_length.append(len(k))
        del k


print row_length
print ncol
print ncol*len(row_length)
print sum(row_length)
