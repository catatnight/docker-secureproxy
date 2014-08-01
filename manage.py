#!/usr/bin/python

import sys
import os
import shlex, subprocess
import argparse

if __name__ == '__main__':
  app_name = 'secureproxy'

  parser = argparse.ArgumentParser(description='Manage %s container' % app_name)
  parser.add_argument("execute", choices=['create','start','stop','restart','delete'], help='manage %s server' % app_name)
  parser.add_argument("--proxy_port", default="", help="proxy port")
  parser.add_argument("--radius_server", default="", help="radius server address")
  parser.add_argument("--radius_secret", default="", help="radius server secret")
  parser.add_argument("--ncsa_users", default="", help="ncsa users' credential e.g. user1:pwd1,user2:pwd2")
  args = parser.parse_args()

  class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

  def _execute(signal):
    if signal == "create" and args.proxy_port == "":
      sys.exit(bcolors.WARNING + "Error: Proxy port must be set. " + bcolors.ENDC)
    signal_dict = {"create" : "docker run --net=host --name {0} -e proxy_port={1} -e radius_server={2} -e radius_radpass={3} -e ncsa_users={4} -e time_zone=Asia/Shanghai -v {5}/certs:/opt/certs -d catatnight/{0}"\
                              .format(app_name, args.proxy_port, args.radius_server, args.radius_secret, args.ncsa_users, os.getcwd()), \
                   "start"  : "docker start   %s" % app_name, \
                   "stop"   : "docker stop    %s" % app_name, \
                   "restart": "docker restart %s" % app_name, \
                   "delete" : "docker rm -f   %s" % app_name}
    process = subprocess.Popen(shlex.split(signal_dict[signal]), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if process.stdout.readline():
      if signal == "create": signal += " and start"
      print bcolors.OKGREEN + signal + " %s successfully" % app_name + bcolors.ENDC
    else:
      _err = process.stderr.readline()
      if 'No such container' in _err:
        print bcolors.WARNING + "Please create %s container first" % app_name + bcolors.ENDC
      else: print bcolors.WARNING + _err + bcolors.ENDC
    output = process.communicate()[0]

  _execute(args.execute)
