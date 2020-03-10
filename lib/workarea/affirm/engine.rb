require 'workarea/affirm'

module Workarea
  module Affirm
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Affirm
    end
  end
end
