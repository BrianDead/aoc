import sys

answer=0
total=0
elves=[]

for line in sys.stdin:
    line=line.rstrip()
    if line == "":
       elves.append(total)
       total=0
    else:
        total+=int(line)

elves.sort(reverse=True)

answer=elves[0]+elves[1]+elves[2]

print("The calories of top 3 elves is {ans}".format(ans=answer))
