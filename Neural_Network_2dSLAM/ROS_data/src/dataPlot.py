#! /usr/bin/env python

import csv
import matplotlib.pyplot as plt
import numpy as np
import ast
from decimal import *

x = []
y = []
getcontext().prec = 5
with open('/home/heyday1006/trial/src/data_read/src/data/MTR.csv') as csv_file:
    plots = csv.reader(csv_file, delimiter=',')
    for row in plots:
        pose=ast.literal_eval(row[1])
        x.append(Decimal(pose[0]))
        y.append(Decimal(pose[1]))

plt.plot(x,y, label='Loaded from file!')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Robot Trajectory')
plt.legend()
plt.savefig('MTR.png')
plt.show()
