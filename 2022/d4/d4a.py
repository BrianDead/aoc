import sys

answer=0
total=0
totalp=0
elves=[]

for line in sys.stdin:
    line=line.rstrip()
    elf1,elf2=line.split(",")

    e1s,e1e=elf1.split("-")
    e2s,e2e=elf2.split("-")

    if(int(e1s)<int(e2s)):
        if(int(e2e)<=int(e1e)):
            total+=1
    elif(int(e1s)==int(e2s)):
        total+=1
    else:
        if(int(e1e)<=int(e2e)):
            total+=1

    if(int(e1s)==int(e2s)):
        totalp+=1
    elif(int(e1s)<int(e2s)):
        if(int(e1e)>=int(e2s)):
            totalp+=1
    else:
        if(int(e2e)>=int(e1s)):
            totalp+=1

print("The number of completely overlapping allocations is {ans}".format(ans=total))
print("The number of partially overlapping allocations is {ans}".format(ans=totalp))
