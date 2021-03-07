# Copyright 2021 Open Rise Robotics Modification
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Base Robot Construction Kit
# https://github.com/rock-core/rock-package_set

require File.join(__dir__, 'autobuild/python')
require File.join(__dir__, 'autobuild/python_setuptools')
require File.join(__dir__, 'autobuild/dsl')

PythonBase.setup_python_configuration_options