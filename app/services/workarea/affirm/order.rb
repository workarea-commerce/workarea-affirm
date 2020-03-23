module Workarea
  module Affirm
    class Order
      module ProductUrl
        include Workarea::I18n::DefaultUrlOptions
        include Storefront::Engine.routes.url_helpers
        extend self
      end

      module ProductImageUrl
        include Workarea::ApplicationHelper
        include Workarea::I18n::DefaultUrlOptions
        include ActionView::Helpers::AssetUrlHelper
        include Core::Engine.routes.url_helpers
        extend self

        def mounted_core
          self
        end
      end

      attr_reader :order, :options

      def initialize(order_id, options = {})
        wa_order = Workarea::Order.find(order_id)
        @order = Workarea::Storefront::OrderViewModel.wrap(wa_order)
        @options = options
      end

      def to_json(*_args)
        to_hash.to_json
      end

      def to_hash
        {
          merchant: merchant,
          shipping: shipping,
          billing: billing,
          items: items,
          order_id: order.id,
          shipping_amount: order.shipping_total.cents,
          tax_amount: order.tax_total.cents,
          total: order.order_balance.cents
        }
      end

      private

      def merchant
        {
          user_confirmation_url: Storefront::Engine.routes.url_helpers.complete_affirm_url(host: host),
          user_cancel_url: Storefront::Engine.routes.url_helpers.checkout_payment_url(host: host),
          user_confirmation_url_action: 'GET',
          name: site_name
        }
      end

      def shipping
        address_data_for(order.shipping_address)
      end

      def billing
        address_data_for(order.billing_address)
      end

      def address_data_for(address)
        {
          name: {
            first: address.first_name,
            last: address.last_name
          },
          address: {
            line1: address.street,
            city: address.city,
            state: address.region,
            zipcode: address.postal_code,
            country: address.country.alpha3
          },
          phone_number: address.phone_number,
          email: order.email
        }
      end

      def items
        Storefront::OrderItemViewModel.wrap(order.items).map do |item|
          {
            display_name: item.product_name,
            sku: item.sku,
            unit_price: item.original_price.cents,
            qty: item.quantity,
            item_image_url: ProductImageUrl.product_image_url(item.image, :detail),
            item_url: ProductUrl.product_url(id: item.product.to_param, host: Workarea.config.host)
          }
        end
      end

      def site_name
        Workarea.config.affirm_merchant_name.to_s
      end

      def host
        "https://#{Workarea.config.host}"
      end
    end
  end
end
