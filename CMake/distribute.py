#!/usr/bin/env python

from __future__ import print_function

from subprocess import Popen, PIPE
from os.path import join, exists, dirname, realpath
from clint.textui.colored import cyan, white
from tempfile import NamedTemporaryFile
from viron.viron import viron

# GOSUB: basicaly `backticks` (cribbed from plotdevice)
def gosub(cmd, on_err=True, verbose=True):
    """ Run a shell command and return the output """
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

def delete(src):
    return gosub('rm %s' % src)

def mkdir_p(pth):
    return gosub('mkdir -p %s' % pth)

def is_framework(library_name):
    return str(library_name)[0].isupper()

def atomic_write(content, target):
    t = NamedTemporaryFile(delete=False)
    t.file.write(content)
    t.file.flush()
    t.close()
    copy(t.name, realpath(target))
    t.unlink(t.name)

wd = dirname(__file__)
source = join(wd, 'Submodule.cmake')
findsource = join(wd, 'FindSubmodule.cmake')
targetname = 'CMakeLists.txt'
findtargetdir = realpath(join(dirname(wd), 'build', 'generated'))

# modules = ('Onigmo', 'cf', 'crash', 'io', 'regexp', 'text')
modules = {
    'Onigmo':   dict(depends=(),
                     libs=()),
    'cf':       dict(depends=('text'),
                     libs=('CoreFoundation', 'ApplicationServices')),
    'crash':    dict(depends=(),
                     libs=()),
    'io':       dict(depends=('text', 'cf', 'regexp', 'crash'),
                     libs=('Carbon', 'Security')),
    'regexp':   dict(depends=('Onigmo', 'text', 'cf'),
                     libs=('iconv')),
    'text':     dict(depends=(),
                     libs=('CoreFoundation',))
}

for modulename in modules.iterkeys():
    modules[modulename]['path'] = realpath(join(dirname(wd), modulename))

if __name__ == '__main__':
    # Read template sources
    with open(source, "rb") as fh:
        cmaketpl = fh.read()
    with open(findsource, "rb") as fh:
        findtpl = fh.read()
    
    # create generated target dir, if necessary
    if not exists(findtargetdir):
        mkdir_p(findtargetdir)
    
    subprojects = " ".join(modules.iterkeys())
    
    for modulename, m in modules.iteritems():
        print(cyan("> Configuring %s" % modulename))
        target = join(m['path'], targetname)
        
        # Get rid of existant file
        if exists(target):
            delete(target)
        
        # Set up {module}/CMakeLists.txt
        libs = list(m['depends'])
        frameworks = []
        for lib in m['libs']:
            is_framework(lib) and frameworks.append(lib) or libs.append(lib)
        cmakelists = viron(cmaketpl, swapdic=dict(
            VIRON_SUBPROJECTS=subprojects,
            VIRON_FRAMEWORKS=" ".join(frameworks),
            VIRON_LIBS=" ".join(libs)),
            warn_unmapped_labels=False)
        atomic_write(cmakelists, target)
        
        # Set up CMake/generated/Find{Module}.cmake
        findtarget = join(dirname(wd), 'generated', 'Find%s.cmake' % modulename.capitalize())
        if exists(findtarget):
            delete(findtarget)
        findmodule = viron(findtpl, swapdic=dict(
            VIRON_SUBMODULE=modulename,
            VIRON_SUBMODULE_UPPER=modulename.upper()),
            warn_unmapped_labels=False)
        atomic_write(findmodule, findtarget)
