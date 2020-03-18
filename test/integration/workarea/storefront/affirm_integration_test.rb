require 'test_helper'

module Workarea
  module Storefront
    class Affirm < Workarea::IntegrationTest
      setup do
        create_tax_category(
          name: 'Sales Tax',
          code: '001',
          rates: [{ percentage: 0.07, country: 'US', region: 'PA' }]
        )

        product = create_product(
          variants: [{ sku: 'SKU1', regular: 6.to_m, tax_code: '001' }]
        )

        create_shipping_service(
          carrier: 'UPS',
          name: 'Ground',
          service_code: '03',
          tax_code: '001',
          rates: [{ price: 7.to_m }]
        )

        post storefront.cart_items_path,
          params: {
            product_id: product.id,
            sku: product.skus.first,
            quantity: 2
          }

        patch storefront.checkout_addresses_path,
          params: {
            email: 'bcrouse@workarea.com',
            billing_address: {
              first_name:   'Ben',
              last_name:    'Crouse',
              street:       '12 N. 3rd St.',
              city:         'Philadelphia',
              region:       'PA',
              postal_code:  '19106',
              country:      'US',
              phone_number: '2159251800'
            },
            shipping_address: {
              first_name:   'Ben',
              last_name:    'Crouse',
              street:       '22 S. 3rd St.',
              city:         'Philadelphia',
              region:       'PA',
              postal_code:  '19106',
              country:      'US',
              phone_number: '2159251800'
            }
          }

        patch storefront.checkout_shipping_path
      end

      def test_handling_affirm_payment_error
        payment = Payment.find(order.id)

        params = { checkout_token: 'total_error' }
        get storefront.complete_affirm_path(params)

        payment.reload
        refute(payment.affirm?)
      end

      def test_placing_order_from_affirm
        Workarea::Affirm::BogusGateway.any_instance.stubs(:get_checkout).returns(get_checkout_response(order.total_price.cents))

        payment = Payment.find(order.id)

        params = { checkout_token: '1234' }

        get storefront.complete_affirm_path(params)

        payment.reload
        order.reload

        assert(order.placed?)

        transactions = payment.tenders.first.transactions
        assert_equal(1, transactions.size)
        assert(transactions.first.success?)
        assert_equal('authorize', transactions.first.action)
      end

      private

      def order
         @order ||= Order.first
       end

      def product
        @product ||= create_product(
          variants: [{ sku: 'SKU1', regular: 6.to_m, tax_code: '001' }]
        )
      end

      def get_checkout_response(amount)
        b = { "total": amount }
          Workarea::Affirm::Response.new(response(b))
      end

      def response(body, status = 200)
        response = Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get("/v2/bogus") { |env| [ status, {}, body.to_json ] }
          end
        end
        response.get("/v2/bogus")
      end
    end
  end
end
