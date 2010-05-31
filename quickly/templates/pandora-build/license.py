#!/usr/bin/python
# -*- coding: utf-8 -*-
# Copyright 2009 Didier Roche
#
# This file is part of Quickly ubuntu-application template
#
#This program is free software: you can redistribute it and/or modify it 
#under the terms of the GNU General Public License version 3, as published 
#by the Free Software Foundation.
#
#This program is distributed in the hope that it will be useful, but 
#WITHOUT ANY WARRANTY; without even the implied warranties of 
#MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR 
#PURPOSE.  See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along 
#with this program.  If not, see <http://www.gnu.org/licenses/>.

import datetime
import filecmp
import os
import re
import shutil
import sys
import ConfigParser

from quickly import configurationhandler, templatetools
from internal import licensing

import gettext
from gettext import gettext as _
# set domain text
gettext.textdomain('quickly')


def help():
    print _("""Usage:
$quickly license <Your_Licence>

Adds license to project files. Before using this command, you should:

1. Edit the file AUTHORS to include your authorship (this step is automatically done
   if you directly launch "$ quickly release" or "$ quickly share" before changing license)
   In this case, license is GPL-3 by default.
2. If you want to put your own quickly unsupported Licence, add a COPYING file containing
   your own licence.
3. Executes either $ quickly license or $ quickly license <License>
   where <License> can be either:
   - GPL-3 (default)
   - GPL-2

This will modify the Copyright file with the chosen licence (with GPL-3 by default).
Updating previous chosen Licence if needed.
If you previously removed the tags to add your own licence, it will leave it pristine.
If no name is attributed to the Copyright, it will try to retrieve it from Launchpad
(in quickly release or quickly share command only)

Finally, this will copy the Copyright at the head of every files.

Note that if you don't run quickly licence before calling quickly release or quickly
share, this one will execute it for you and guess the copyright holder from your
launchpad account if you didn't update it.
""")

def shell_completion(argv):
    """Propose available license as the third parameter"""
    
    # if then license argument given, returns available licenses
    if len(argv) == 1:
        print " ".join(licensing.get_supported_licenses())


if __name__ == "__main__":

    templatetools.handle_additional_parameters(sys.argv, help, shell_completion)
    license = None
    if len(sys.argv) > 2:
        print _("This command only take one optional argument: License\nUsage is: quickly license <license>")
        sys.exit(4)
    if len(sys.argv) == 2:
        license = sys.argv[1]
    try:
        licensing.licensing(license)
    except LicenceError, error_message:
        print(error_message)
        sys.exit(1)

