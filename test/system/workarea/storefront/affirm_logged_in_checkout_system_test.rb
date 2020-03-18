require 'test_helper'

module Workarea
  module Storefront
    class AffirmLoggedInCheckoutSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :set_affirm
      setup :setup_checkout_specs
      setup :add_user_data
      setup :start_user_checkout

      def set_affirm
        Workarea.config.affirm_public_key = 'x'
        Workarea.config.affirm_private_key = 'y'
      end

      def test_affirm_option_in_checkout
        choose 'payment_affirm'
        assert(page.has_content?(I18n.t('workarea.storefront.affirm.on_continue')))
      end
    end
  end
end
