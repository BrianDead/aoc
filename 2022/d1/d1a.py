import sys

answer=0
total=0

for line in sys.stdin:
    line=line.rstrip()
    if line == "":
       answer=max(total, answer)
       total=0
    else:
        total+=int(line)

print("The highest calories by any elf is {ans}".format(ans=answer))
