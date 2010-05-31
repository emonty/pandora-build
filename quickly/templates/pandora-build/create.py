#!/usr/bin/python
# -*- coding: utf-8 -*-
# Copyright © 2010 Monty Taylor
# Copyright 2009 Didier Roche
#
# This file is part of Quickly drizzle-plugin template
#
#This program is free software: you can redistribute it and/or modify it 
#under the terms of the GNU General Public License version 3, as published 
#by the Free Software Foundation.

#This program is distributed in the hope that it will be useful, but 
#WITHOUT ANY WARRANTY; without even the implied warranties of 
#MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR 
#PURPOSE.  See the GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along 
#with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys
import os
import shutil
import subprocess

from quickly import templatetools, configurationhandler, tools
from internal import quicklyutils, naming, pandoramacros, createoradd

import gettext
from gettext import gettext as _
# set domain text
gettext.textdomain('quickly')

project_root_prefix = "project_root_"
print "ass bandits"


def help():
    print _("""Usage:
$ quickly create pandora-build project_name project_type

where "project_name" is the name of the project to create.

This will create a new project dir with the initial skeleton files needed.
""")
templatetools.handle_additional_parameters(sys.argv, help)


# get the name of the project
if len(sys.argv) < 2:
    print _("""Project name not defined.\n""")
if len(sys.argv) < 3:
    print _("""Plugin Type not defined.\nUsage is quickly create pandora-build plugin_name plugin_type""")
    sys.exit(4)

createoradd.create_project(sys.argv[1:])



# add it to revision control
print _("Adding to bzr repository and commiting")
bzr_instance = subprocess.Popen(["bzr", "add"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
if bzr_instance.wait() != 0:
  # We are not in a bzr branch yet. Create one.
  print _("Creating bzr branch")
  bzr_instance = subprocess.Popen(["bzr", "init"], stdout=subprocess.PIPE)
  bzr_instance.wait()
  bzr_instance = subprocess.Popen(["bzr", "add"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
  bzr_instance.wait()

bzr_instance = subprocess.Popen(["bzr", "commit", "-m", "Initial project creation with Quickly!", "."], stderr=subprocess.PIPE)
bzr_instance.wait()

print _("Congrats, your new project is setup! cd %s/ to start hacking.") % os.getcwd()

sys.exit(0)
