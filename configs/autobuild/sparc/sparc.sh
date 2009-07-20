#!/bin/bash
#
# $Id$
#

PATH=/opt/csw/bin:/opt/SUNWspro/bin:$PATH
export PATH

# OpenSSL requires an explicit source of entropy on Solaris.  The
# Entropy Gathering Daemon perl script fulfills that requirement.

exec $HOME/autobuild/autobuild.pl \
     $HOME/autobuild/configs/autobuild/sparc/SunOS10_GCC402.xml 2>&1

exec $HOME/autobuild/autobuild.pl \
     $HOME/autobuild/configs/autobuild/sparc/SunOS10_Studio9.xml 2>&1

