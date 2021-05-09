# Copyright Base Robot Construction Kit
# https://github.com/rock-core/rock-package_set

require 'autoproj'
require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'
require 'flexmock/minitest'

module Helpers
    def create_autoproj_workspace
        ws = Autoproj::Workspace.new
        ws.set_as_main_workspace
        ws
    end
end

module Minitest
    class Test
    include Helpers
    end
end
