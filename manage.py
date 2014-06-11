#!/usr/bin/python

import shlex, subprocess
import argparse

if __name__=="__main__":
  parser = argparse.ArgumentParser(description='Manage spdyproxy container')
  parser.add_argument("execute", help="start|stop|restart spdyproxy server")
  args = parser.parse_args()

  class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

  def _start():
    bashCommand = "docker run --net=host --name spdyproxy -d catatnight/spdyproxy"
    process = subprocess.Popen(shlex.split(bashCommand), stdout=subprocess.PIPE)
    if process.stdout.readline() != "":
      print bcolors.OKGREEN + "Spdyproxy started successfully" + bcolors.ENDC
    output = process.communicate()[0]

  def _stop():
    bashCommand = "docker rm -f spdyproxy"
    process = subprocess.Popen(shlex.split(bashCommand), stdout=subprocess.PIPE)
    if process.stdout.readline() != "":
      print bcolors.OKGREEN + "Spdyproxy stopped successfully" + bcolors.ENDC
    output = process.communicate()[0]

  if args.execute== "start":
    _start()
  elif args.execute== "stop":
    _stop()
  elif args.execute== "restart":
    _stop()
    _start()
