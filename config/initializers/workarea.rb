Workarea.configure do |config|
  config.tender_types.append(:affirm)

  config.affirm = ActiveSupport::Configurable::Configuration.new
  config.affirm.api_timeout = 5
  config.affirm.open_timeout = 5
end
