#!/usr/bin/env python

from glob import glob
from os.path import join, exists, dirname, realpath
from distribute import delete, modules, targetname

def pycs(subdir):
    if not exists(subdir):
        return []
    return glob(realpath(join(subdir, "*.pyc")))

def generated():
    return glob(realpath(join(dirname(__file__), 'generated', "*.cmake")))

if __name__ == '__main__':
    for module in modules.keys():
        target = join(module, targetname)
        if exists(target):
            delete(target)
    for findfile in generated():
        delete(generated)
    for pyc in pycs(dirname(__file__)):
        delete(pyc)