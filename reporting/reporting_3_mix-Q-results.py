import json
import math
import matplotlib.pyplot as plt
import sys
import os
from matplotlib.backends.backend_pdf import PdfPages

filename="../cplex/model01/log-tests-model01-hfree-1512596874.242562.txt"
if len(sys.argv) >1:
    filename=sys.argv[1]

if not os.path.exists(filename):
    exit()

log = json.load(open(filename))


results = {}
for elem in log:
    for k,v in elem.items():
        if  "time" in v:
            results[k[:-4]]= float(v["time"])

results_list = sorted(results.items())
x,y = zip(*results_list)

print(results)
print(x)
print(y)

# csv file
# csv file

f = open(filename+".report3-compare.csv","w")
f.write("instance,objective_fuction, solve_time(s),||, objective_fuction2, solve_time2(s)\n")
for elem in log:
    for k,v in elem.items():
        if "time" in v and "ObjectiveFunction" in v:
            # search for k  in f1
            init=",,,"

            f1 = open("log-x_all-Q.json",'r')
            for line in f1.readlines():
                #print(line)
                if line.startswith(k):
                    print("match with "+k)
                    init=line[:-1]
                    break
            f1.close()

            # get line of f1, the append line
            f.write(init+"||"+str(k)+","+str(v["ObjectiveFunction"])+","+str(v["time"])+"\n")

f.close()

# plot Q results
f1 = open("log-x_all-Q.json",'r')
x2 = []
y2 = []
for line in f1.readlines():
    if not line.startswith("x_9") and not line.startswith("x_8"):
        #print(line)
        i = line.find(",")
        x2.append(line[:i])
        j = line[i+1:].find(",")
        #print(line[i+1+j+1:-1])
        y2.append(float(line[i+1+j+1:-1]))


f1.close()


# prepare pdf
pp = PdfPages(filename+'.report3.pdf')

# plot 
fig, ax = plt.subplots() 
plt.plot(range(len(x)),y, marker='o', color='g', ls='')
plt.plot(range(len(x2)),y2, marker='o', color='r', ls='')


#plt.bar(range(len(y)),y, align='center')
plt.xticks(range(len(x2)),x2)

#plt.xticks(rotation='vertical')
plt.xticks(rotation=45, ha='right')

plt.xlabel('instance name')
plt.ylabel('Solve time(s)')

#fig.subplots_adjust(bottom=0.9)
fig.tight_layout()
#plt.axis([0, len(results), 0, max(y)])

plt.savefig(pp, format='pdf')
pp.close()

plt.show()
