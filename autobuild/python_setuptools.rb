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

module Autobuild
  def self.python_setuptools(options, &block)
      PythonSetuptools.new(options, &block)
  end

  class PythonSetuptools < Autobuild::Python
      def initialize(options)
          super(options)
          @mutex = Mutex.new
      end

      def generate_install_data_command
        command = ['python', 'setup.py', 'install_data']
        command << "--install-dir=#{prefix}"
        command
      end

      def install_data
        return unless install_mode?

        command = generate_install_data_command
        command << '--force' if @forced
        progress_start 'installing data %s',
                       done_message: 'installed %s' do
            run 'install_data', *command, working_directory: srcdir
        end
      end

      def update_srcdir
          @importdir ||= @srcdir
          return if File.exist?(File.join(srcdir, 'package.xml'))

          usual_manifestdir = File.join(srcdir, name, 'package.xml')

          if File.exist?(usual_manifestdir)
              @srcdir = File.dirname(usual_manifestdir)
              return
          end

          dir_glob = "#{importdir}/**/#{name}/package.xml"
          @srcdir = (Dir[dir_glob].map do |path|
              File.dirname(path)
          end.first || @srcdir)
      end

      def install
        super
        install_data
      end

      def import(options)
          @mutex.synchronize do
              return if updated? || failed?

              result = super(**options)
              update_srcdir
              result
          end
      end
  end
end
