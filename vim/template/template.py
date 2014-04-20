#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, os
from optparse import OptionParser

def create_parser(argv):
  usage = 'usage: %prog [options] file'
  version = '%prog 0.0.1'
  parser = OptionParser(usage=usage, version=version)
  (options, args) = parser.parse_args(argv)
  return parser, options, args

def main(argv):
  (parser, options, args) = create_parser(argv)

if __name__ == '__main__':
  main(sys.argv[1:])
  <+CURSOR+>
