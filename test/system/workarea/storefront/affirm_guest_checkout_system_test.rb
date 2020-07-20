require 'test_helper'

module Workarea
  module Storefront
    class AffirmGuestCheckoutSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :set_affirm
      setup :setup_checkout_specs
      setup :start_guest_checkout

      def set_affirm
        Workarea.config.affirm_public_key = 'x'
        Workarea.config.affirm_private_key = 'y'
      end

      def fill_in_shipping_address
        fill_in 'shipping_address[first_name]',   with: 'Ben'
        fill_in 'shipping_address[last_name]',    with: 'Crouse'
        fill_in 'shipping_address[street]',       with: '22 S. 3rd St.'
        fill_in 'shipping_address[city]',         with: 'Philadelphia'

        if page.has_field?('shipping_address[region]')
          fill_in 'shipping_address[region]', with: 'PA'
        else
          select 'Pennsylvania', from: 'shipping_address_region_select'
        end

        fill_in 'shipping_address[postal_code]',  with: 'XXXXX'
        fill_in 'shipping_address[phone_number]', with: '2159251800'
      end

      def test_successfully_checking_out
        assert_current_path(storefront.checkout_addresses_path)
        fill_in_email
        fill_in_shipping_address
        uncheck 'same_as_shipping'
        fill_in_billing_address
        click_button t('workarea.storefront.checkouts.continue_to_shipping')

        assert_current_path(storefront.checkout_shipping_path)
        assert(page.has_content?('Success'))

        click_button t('workarea.storefront.checkouts.shipping_instructions_prompt')
        instruction = 'Doorbeel broken, please knock'
        fill_in :shipping_instructions, with: instruction

        click_button t('workarea.storefront.checkouts.continue_to_payment')

        assert_current_path(storefront.checkout_payment_path)
        assert(page.has_content?('Success'))

        assert(page.has_content?('22 S. 3rd St.'))
        assert(page.has_content?('Philadelphia'))
        assert(page.has_content?('PA'))
        assert(page.has_content?('XXXXX'))
        assert(page.has_content?('Ground'))

        assert(page.has_content?('Integration Product'))
        assert(page.has_content?('SKU'))

        assert(page.has_content?('$5.00')) # Subtotal
        assert(page.has_content?('$7.00')) # Shipping
        assert(page.has_content?('$0.84')) # Tax
        assert(page.has_content?('$12.84')) # Total

        assert(page.has_content?(instruction))

        choose 'payment_affirm'
        click_button t('workarea.storefront.checkouts.place_order')
        wait_for_iframe

        assert_text('We encountered a problem with your checkout.')

        click_button 'Return to the Merchant'

        assert_current_path(storefront.cart_path)
      end
    end
  end
end
