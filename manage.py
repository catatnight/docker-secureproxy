#!/usr/bin/python

import shlex, subprocess
import argparse

if __name__=="__main__":
  parser = argparse.ArgumentParser(description='Manage spdyproxy container')
  parser.add_argument("execute", choices=['create','start','stop','restart','delete'], help="manage spdyproxy server")
  args = parser.parse_args()

  class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

  def _execute(signal):
    signal_dict = {"create" : "docker run --net=host --name spdyproxy -d catatnight/spdyproxy", \
                   "start"  : "docker start   spdyproxy", \
                   "stop"   : "docker stop    spdyproxy", \
                   "restart": "docker restart spdyproxy", \
                   "delete" : "docker rm -f   spdyproxy"}
    process = subprocess.Popen(shlex.split(signal_dict[signal]), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if process.stdout.readline():
      if signal == "create": signal += " and start"
      print bcolors.OKGREEN + signal + " spdyproxy successfully" + bcolors.ENDC
    else:
      _err = process.stderr.readline()
      if 'No such container' in _err:
        print bcolors.WARNING + "Please create spdyproxy container first" + bcolors.ENDC
      else: print bcolors.WARNING + _err + bcolors.ENDC
    output = process.communicate()[0]

  _execute(args.execute)
