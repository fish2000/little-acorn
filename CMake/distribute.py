#!/usr/bin/env python

from __future__ import print_function

from os import getcwd, unlink
from os.path import join, exists
from shutil import copy2
from clint.textui.colored import cyan, white

wd = getcwd()
source = join(wd, 'Submodule.cmake')
targetname = 'CMakeLists.txt'

modules = (join(wd, m) for m in ('Onigmo', 'cf', 'crash', 'io', 'regexp', 'text'))

for module in modules:
    target = join(module, targetname)
    if exists(target):
        unlink(target)
        print(cyan("* Deleted CMakeLists.txt in %s" % module))
    copy2(source, target)
    print(white("> Created CMakeLists.txt submodule in %s" % module))
