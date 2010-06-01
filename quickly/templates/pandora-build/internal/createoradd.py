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
import datetime

from quickly import templatetools, configurationhandler, tools
from internal import quicklyutils, naming, pandoramacros, licensing

import gettext
from gettext import gettext as _
# set domain text
gettext.textdomain('quickly')

def _get_names(argv):
    path_and_project = argv[0].split('/')

    names = None
    type_names = None
# check that project name follow quickly rules and reformat it.
# TODO: need to handle input in the form of StoragEngine and turn it in to
#  storage_engine, Storage Engine, STORAGE_ENGINE and StorageEngine
#  respectively
    try:
        names = naming.naming_context(path_and_project[-1])
        type_names = naming.naming_context(argv[1])
    except templatetools.bad_project_name, e:
        print(e)
        sys.exit(1)
    return names, type_names


def _create_project(names, type_names, project_type="project_root"):
    project_root_prefix = "%s_" % project_type

    include_guard_names = []
    include_guard_names.append(names.all_caps_name)
    include_guard_names.append(names.all_caps_name)
    include_guard_names.append("H")
    include_guard = "_".join(include_guard_names)

    open_namespace = "namespace %s\n{" % names.project_name
    close_namespace = "} /* namespace %s */" % names.project_name

    author_name = "Your Name"
    full_copyright_line = "YYYY <Your Name> <Your E-mail>"
    bzr_whoami = subprocess.Popen(["bzr","whoami"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    bzr_output, bzr_errors= bzr_whoami.communicate()
    if bzr_output.find('.', bzr_output.find('@')) != -1:
        author_name = bzr_output.strip()
        full_copyright_line = "%s %s" % (datetime.datetime.now().year, author_name) 

    substitutions = (
                ("type_camel_case_name",type_names.camel_case_name),
                ("type_sentence_name",type_names.sentence_name),
                ("plugin_type",type_names.project_name),
                ("include_guard", include_guard),
                ("all_caps_project_name", names.all_caps_name),
                ("project_name",names.project_name),
                ("camel_case_name",names.camel_case_name),
                ("sentence_name",names.sentence_name),
                ("all_caps_name",names.all_caps_name),
                ("class_name",names.project_name),
                ("open_namespace",open_namespace),
                ("close_namespace",close_namespace),
                ("author_name",author_name),
                ("full_copyright_line",full_copyright_line),
                )



# get origin path
    pathname = templatetools.get_template_path_from_project()

    for abs_path_project_root in [os.path.join(pathname, f) for f in (project_type, '%s%s' % (project_root_prefix, type_names.project_name))]:
        if os.path.isdir(abs_path_project_root):
            for root, dirs, files in os.walk(abs_path_project_root):
                try:
                    relative_dir = root.split('%s/' % abs_path_project_root)[1]
                except:
                    relative_dir = ""
                # python dir should be replace by python (project "pythonified" name)
                if relative_dir.startswith('project_name'):
                    relative_dir = relative_dir.replace('project_name', names.project_name)
             
                for directory in dirs:
                    if directory == 'project_name':
                        directory = names.project_name
                    try:
                        os.mkdir(os.path.join(relative_dir, directory))
                    except OSError:
                        # We don't care - we may be merging dirs
                        pass
                for filename in files:
                    quicklyutils.file_from_template(root, filename, relative_dir, substitutions)


# We're not in create, so we've got to deal with the directory creation
# ourselves
def create_plugin(argv):
    names, type_names = _get_names(argv)

    if os.path.isdir("plugin"):
        # We're in the root dir
        plugin_dir = os.path.join("plugin", names.base_name)
        os.mkdir(plugin_dir)
        os.chdir(plugin_dir)
    elif os.isdir("../plugin"):
        # We're in plugin root dir
        os.mkdir(names.base_name)
        os.chdir(names.base_name)
    else:
        # Don't know where the hell we are
        print("""add plugin was called from an odd location.
Please either call it from the plugin dir or from the root of the source
tree""")
        sys.exit(4)

    _create_project(names, type_names, project_type="drizzle_plugin")
    return names.base_name
    
def create_project(argv):
    names, type_names = _get_names(argv)
    os.chdir(names.quickly_name)

    _create_project(names, type_names)
    try:
        os.mkdir("m4")
    except OSError:
        pass

    pandoramacros.copy_pandora_files()
        
    try:
        os.chmod("config/autorun.sh", 0755)
        os.chmod("config/pandora-plugin", 0755)
        os.chmod("config/config.rpath", 0755)
        os.chmod("test_run.sh", 0755)
    except:
        pass

    pandora_version = pandoramacros.get_pandora_version()

    licensing.licensing("GPL-3")

    configurationhandler.loadConfig()
    configurationhandler.project_config['project-type'] = type_names.project_name
    configurationhandler.project_config['pandora-version'] = pandora_version
    configurationhandler.saveConfig()
