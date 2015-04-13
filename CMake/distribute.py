#!/usr/bin/env python

from __future__ import print_function

from os import unlink
from os.path import join, exists, basename, dirname, realpath
from clint.textui.colored import cyan, white

# GOSUB: basicaly `backticks` (cribbed from plotdevice)
def gosub(cmd, on_err=True, verbose=True):
    """ Run a shell command and return the output """
    from subprocess import Popen, PIPE
    if verbose:
        print(white(cmd))
    shell = isinstance(cmd, basestring)
    proc = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=shell)
    out, err = proc.communicate()
    ret = proc.returncode
    if on_err:
        msg = '%s:\n' % on_err if isinstance(on_err, basestring) else ''
        assert ret==0, msg + (err or out)
    return out, err, ret

def copy(src, dst):
    return gosub('cp -p %s %s' % (src, dst))

wd = dirname(__file__)
source = join(wd, 'Submodule.cmake')
targetname = 'CMakeLists.txt'

modules = (join(dirname(wd), m) for m in ('Onigmo', 'cf', 'crash', 'io', 'regexp', 'text'))

if __name__ == '__main__':
    for module in modules:
        target = join(module, targetname)
        if exists(target):
            unlink(target)
            print(cyan("* Deleted CMakeLists.txt in %s" % basename(module)))
        copy(realpath(source), realpath(target))
        # print(white("> Created CMakeLists.txt submodule in %s" % module))
