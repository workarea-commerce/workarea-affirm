require 'test_helper'

module Workarea
  module Storefront
    class CartSystemTest < Workarea::SystemTest
      setup :set_inventory
      setup :set_product
      setup :set_affirm

      def set_inventory
        create_inventory(id: 'SKU1', policy: 'standard', available: 2)
      end

      def set_product
        @product = create_product(
          name: 'Integration Product',
          variants: [
            { name: 'SKU1', sku: 'SKU1', regular: 5.to_m },
            { name: 'SKU2', sku: 'SKU2', regular: 6.to_m }
          ]
        )
      end

      def set_affirm
        Workarea.config.affirm_public_key = 'x'
        Workarea.config.affirm_private_key = 'y'
      end

      def test_order_value_does_not_meet_affirm_threshold
        Workarea.config.affirm_minimum_order_value = 500.00

        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')

        assert(page.has_content?('Success'))
        assert(page.has_content?(@product.name))

        click_link t('workarea.storefront.carts.view_cart')
        refute(page.has_selector?('.affirm-as-low-as', visible: false))
      end

      def test_order_does_not_qualify
        @product.update!(affirm_available: false)

        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')

        assert(page.has_content?('Success'))
        assert(page.has_content?(@product.name))

        click_link t('workarea.storefront.carts.view_cart')
        refute(page.has_selector?('.affirm-as-low-as', visible: false))
      end

       def test_show_affirm_message
        Workarea.config.affirm_minimum_order_value = nil

        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')

        assert(page.has_content?('Success'))
        assert(page.has_content?(@product.name))

        click_link t('workarea.storefront.carts.view_cart')
        assert(page.has_selector?('.affirm-as-low-as', visible: false))
      end
    end
  end
end
