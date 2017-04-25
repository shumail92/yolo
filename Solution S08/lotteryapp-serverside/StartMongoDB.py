import os
import platform
import subprocess


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


dbPort = "27017"
print(bcolors.OKBLUE + "\n\nTrying to start your local mongoDB server on port {}...".format(dbPort) + bcolors.ENDC)
try:
	ret = subprocess.call(["mongod", "--dbpath", "./data/db/", "--port", "27017"])
except:
	print(bcolors.WARNING + "Stopped running your mongoDB server!" + bcolors.ENDC)
