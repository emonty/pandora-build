# -*- coding: utf-8 -*-
#
# Copyright © 2011 Monty Taylor
#
# This file is part of Quickly pandora-build template
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

import os
import subprocess

from internal import pandoramacros

def add_and_commit(new_file_list):

  add_command = []
  commit_command = []

  if os.path.isdir(".bzr"):
    add_command = ["bzr", "add"]
    commit_command = ["bzr", "commit", "-m"]
    commit_command = ["bzr", "commit", "-m"]
  elif os.path.isdir(".git"):
    add_command = ["git", "add", "-f"]
    commit_command = ["git", "commit", "-m"]
  else:
    return

  add_command.extend(new_file_list)
  add_command.append('.quickly')
  vc_instance = subprocess.Popen(add_command,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
  vc_instance.wait()

  commit_command.append("Updated pandora-build files to version %s" % pandoramacros.get_pandora_version())
  commit_command.extend(new_file_list)
  commit_command.append('.quickly')
  vc_instance = subprocess.Popen(commit_command,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
  vc_instance.wait()
