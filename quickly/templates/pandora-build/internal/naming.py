# -*- coding: utf-8 -*-
# Copyright © 2010 Monty Taylor
# Copyright 2009 Didier Roche
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

import re


class naming_context(object):

    _name_splitter = re.compile('([A-Z]*[a-z]+)[-_]*')
    def __init__(self, base_name):
        self._base_name = base_name

        self._name_list = self._name_splitter.findall(base_name)

        self._quickly_name = base_name.lower()
        self._project_name = "_".join([f.lower() for f in self._name_list])

        self._all_caps_name = "_".join([f.upper() for f in self._name_list])

        self._sentence_name = " ".join([f.title() for f in self._name_list])

        self._pascal_case_name = "".join([f.title() for f in self._name_list])
        self._camel_case_name = "".join([self._name_list[0].lower()] + [f.title() for f in self._name_list[1:]])

        
    @property
    def base_name(self):
        return self._base_name

    @property
    def project_name(self):
        return self._project_name

    @property
    def all_caps_name(self):
        return self._all_caps_name

    @property
    def sentence_name(self):
        return self._sentence_name

    @property
    def camel_case_name(self):
        return self._pascal_case_name

    @property
    def quickly_name(self):
        return self._quickly_name
