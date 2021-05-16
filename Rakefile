# As it is Robot Construction Kit
# https://github.com/rock-core/rock-package_set

require "rake/testtask"

require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options << '--except'
  task.options << 'Naming/MethodParameterName'
end

Rake::TestTask.new(:test) do |t|
    t.libs << "."
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
end
