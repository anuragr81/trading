#!/usr/bin/python
import sys

def list2str(args):
    arg_string = ""
    prefix = ""
    for arg in args:
      arg_string = arg_string + prefix + str(arg)
      prefix = " " 
    return arg_string;

print list2str(sys.argv)
