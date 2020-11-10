require 'test_helper'

module Workarea
  module Affirm
    class OrderTest < Workarea::IntegrationTest
      def test_to_hash
        Workarea.config.affirm_merchant_name = "Workarea test merchant"
        discount = create_order_total_discount(promo_codes: %w[TESTCODE])
        order = Workarea::Storefront::OrderViewModel.new(
          create_multi_item_placed_order(
            promo_codes: %w[TESTCODE]
          )
        )
        product = Catalog::Product.find(order.items.first.product_id)
        categories = [
          create_category(
            name: 'Manual',
            product_ids: [order.items.first.product_id]
          ),
          create_category(
            name: 'Rules',
            product_rules: [
              { name: 'search', operator: 'equals', value: product.name }
            ]
          )
        ]

        hash = Order.new(order.id).to_hash

        assert_equal(order.id, hash[:order_id])
        assert_equal(order.order_balance.cents, hash[:total])
        assert_equal(order.tax_total.cents, hash[:tax_amount])
        assert_equal(order.shipping_total.cents, hash[:shipping_amount])
        assert_equal(Money.default_currency.iso_code, hash[:currency])

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
        assert_equal("Test Product 2", affirm_item[:display_name])
        assert_equal("SKU2", affirm_item[:sku])
        assert_equal(500, affirm_item[:unit_price])
        assert_equal(2, affirm_item[:qty])
        assert_includes(affirm_item[:categories], categories.first.name)
        assert_includes(affirm_item[:categories], categories.second.name)

        affirm_item = hash[:items].second
        assert_equal("Test Product 1", affirm_item[:display_name])
        assert_equal("SKU1", affirm_item[:sku])
        assert_equal(500, affirm_item[:unit_price])
        assert_equal(2, affirm_item[:qty])
        assert_includes(affirm_item[:categories], categories.second.name)

        metadata = hash[:metadata]
        assert_equal('Workarea', metadata[:platform_type])
        assert_equal(Workarea::VERSION::STRING, metadata[:platform_version])
        assert_equal(Workarea::Affirm::VERSION, metadata[:platform_affirm])

        discounts = hash[:discounts]

        refute_empty(discounts)

        promo = discounts[discount.id.to_s]

        refute_nil(promo, discounts)
        assert_equal(200, promo[:discount_amount])
        assert_equal(discount.name, promo[:discount_display_name])
      end

      private

      def create_multi_item_placed_order(overrides = {})
        attributes = factory_defaults(:placed_order).merge(overrides)

        shipping_service = create_shipping_service
        sku1 = 'SKU1'
        sku2 = 'SKU2'
        create_product(name: 'Test Product 1', variants: [{ sku: sku1, regular: 5.to_m }])
        create_product(name: 'Test Product 2', variants: [{ sku: sku2, regular: 5.to_m }])
        order = Workarea::Order.new(attributes)

        [sku1, sku2].each do |sku|
          details = OrderItemDetails.find(sku)
          item = { sku: sku, quantity: 2 }.merge(details.to_h)

          order.add_item(item)
        end

        checkout = Checkout.new(order)
        checkout.update(
          factory_defaults(:checkout_payment).merge(
            shipping_address: factory_defaults(:shipping_address),
            billing_address: factory_defaults(:billing_address),
            shipping_service: shipping_service.name,
          )
        )

        unless checkout.place_order
          raise(
            UnplacedOrderError,
            'failed placing the order in the create_placed_order factory'
          )
        end

        forced_attrs = overrides.slice(:placed_at, :update_at, :total_price)
        order.update_attributes!(forced_attrs)
        order
      end
    end
  end
end
