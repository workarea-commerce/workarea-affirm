require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::Affirm::Engine.root
  Workarea::Teaspoon.apply(config)
end
