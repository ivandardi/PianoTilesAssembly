import sys

with open(sys.argv[1], "r") as f:
    data = f.read()

data = data.replace("\n", " ").split()

with open(sys.argv[1][:-4] + '_out.txt', "w") as f:
    print(', '.join(data), file=f)
