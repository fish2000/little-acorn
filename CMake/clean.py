#!/usr/bin/env python

from os.path import join, exists
from distribute import gosub, modules, targetname

def delete(src):
    return gosub('rm %s' % src)

if __name__ == '__main__':
    for module in modules:
        target = join(module, targetname)
        if exists(target):
            delete(target)