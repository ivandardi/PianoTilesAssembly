import sys

with open(sys.argv[1], "r") as f:
	data = f.read()

data = data.replace("\n", " ").split()

with open(sys.argv[1].replace(".txt", ".img"), "wb") as f:
	for s in data:
		f.write(int(s, 16).to_bytes(4, byteorder='big'))
