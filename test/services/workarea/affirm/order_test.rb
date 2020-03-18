require 'test_helper'

module Workarea
  module Affirm
    class OrderTest < Workarea::TestCase
      def test_to_hash
        Workarea.config.affirm_merchant_name = "Workarea test merchant"
        order = Workarea::Storefront::OrderViewModel.new(create_placed_order)

        hash = Order.new(order.id).to_hash

        assert_equal(order.id, hash[:order_id])
        assert_equal(order.order_balance.cents, hash[:total])
        assert_equal(order.tax_total.cents, hash[:tax_amount])
        assert_equal(order.shipping_total.cents, hash[:shipping_amount])

        assert_equal("Workarea test merchant", hash[:merchant][:name])

        affirm_shipping = hash[:shipping]
        assert_equal({ first: "Ben", last: "Crouse" }, affirm_shipping[:name])
        assert_equal(order.email, affirm_shipping[:email])
        assert_equal(order.shipping_address.street, affirm_shipping[:address][:line1])
        assert_equal(order.shipping_address.city, affirm_shipping[:address][:city])
        assert_equal(order.shipping_address.region, affirm_shipping[:address][:state])
        assert_equal(order.shipping_address.postal_code, affirm_shipping[:address][:zipcode])
        assert_equal(order.shipping_address.country.alpha3, affirm_shipping[:address][:country])

        affirm_billing = hash[:billing]
        assert_equal({ first: "Ben", last: "Crouse" }, affirm_billing[:name])
        assert_equal(order.email, affirm_billing[:email])
        assert_equal(order.billing_address.street, affirm_billing[:address][:line1])
        assert_equal(order.billing_address.city, affirm_billing[:address][:city])
        assert_equal(order.billing_address.region, affirm_billing[:address][:state])
        assert_equal(order.billing_address.postal_code, affirm_billing[:address][:zipcode])
        assert_equal(order.billing_address.country.alpha3, affirm_billing[:address][:country])

        affirm_item = hash[:items].first
        assert_equal("Test Product", affirm_item[:display_name])
        assert_equal("SKU", affirm_item[:sku])
        assert_equal(500, affirm_item[:unit_price])
        assert_equal(2, affirm_item[:qty])
      end
    end
  end
end
