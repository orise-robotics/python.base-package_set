# Copyright 2021 Open Rise Robotics
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

require 'autobuild/configurable'

module Autobuild
  def self.python_setuptools(options, &block)
      PythonSetuptools.new(options, &block)
  end

  class PythonSetuptools < Autobuild::Python
      def initialize(options)
          super(options)
          @python_bin = Autoproj.workspace.config.get('python_executable', nil)
          setup_tests
          @mutex = Mutex.new
      end

      def generate_install_data_command
        command = [@python_bin, 'setup.py', 'install_data']
        command << "--install-dir=#{prefix}"
        command
      end

      def generate_tests_data_command(test_file)
        test_utility.source_ref_dir = builddir
        command = [@python_bin , '-m', 'pytest']
        command << "-o"
        command << "cache_dir=#{@builddir}"
        command << "--tb=short"
        test_name = File.basename(test_file, ".*")
        testsout_filename = File.join(@builddir, 'test_results', @name, "#{test_name}.xml")
        command << "--junit-xml=#{testsout_filename}"
        command << test_file
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

      def install
        super
        install_data
      end

      def setup_tests
        unless test_utility.has_task?
          test_dir = File.join(srcdir, 'test')
          if File.directory?(test_dir)
            test_utility.source_dir = File.join('test_results', name)
          end
  
          with_tests if test_dir
        end
      end

      # Copied from cmake to use doc and tests
      def common_utility_handling(utility, target, start_msg, done_msg)
        utility.task do
            progress_start start_msg, :done_message => done_msg do
                all_files = Dir["#{srcdir}/test/**/test_*.py"]
                all_files.each do |test_file|
                    run(utility.name,
                    *generate_tests_data_command(test_file),
                    working_directory: srcdir)
                end
                yield if block_given?
            end
        end
      end

      def with_tests(target = 'test', &block)
        common_utility_handling(
            test_utility, target,
            "running tests for %s",
            "successfully ran tests for %s", &block)
      end

      def import(options)
          @mutex.synchronize do
              return if updated? || failed?
              result = super(**options)
              result
          end
      end
  end
end
