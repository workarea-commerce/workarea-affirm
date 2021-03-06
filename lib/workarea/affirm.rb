require 'workarea'
require 'workarea/affirm/engine'
require 'workarea/affirm/version'

require 'workarea/affirm/gateway'
require 'workarea/affirm/response'
require 'workarea/affirm/bogus_gateway'

module Workarea
  module Affirm
    def self.public_key
      Workarea.config.affirm_public_key
    end

    def self.private_key
      Workarea.config.affirm_private_key
    end

    def self.api_configured?
      public_key.present? && private_key.present?
    end

    def self.enabled?
      Workarea.config.affirm_enabled && api_configured?
    end

    def self.js_sdk_url
      if test?
        "https://cdn1-sandbox.affirm.com/js/v2/affirm.js"
      else
        "https://cdn1.affirm.com/js/v2/affirm.js"
      end
    end

    def self.test?
      !Workarea.config.affirm_use_production_environment
    end

    def self.gateway(_options = {})
      if Rails.env.test?
        Affirm::BogusGateway.new
      else
        Affirm::Gateway.new(
          test: test?,
          public_key: public_key,
          private_key: private_key
        )
      end
    end
  end
end
