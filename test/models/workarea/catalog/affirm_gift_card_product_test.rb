require 'test_helper'

module Workarea
  module Catalog
    class AffirmGiftCardProductTest < TestCase
      if Workarea::Plugin.installed? :gift_cards
        def test_gift_cards_cannot_be_purchased_with_affirm
          product = create_product(gift_card: true)

          assert(product.gift_card?)
          refute(product.affirm_available?)
          refute(product.update(affirm_available: true))
          assert(product.errors[:affirm_available].present?)
          assert(product.update(affirm_available: true, gift_card: false))

          product = create_product(affirm_available: true)

          assert(product.affirm_available?)
          refute(product.gift_card?)
        end
      end
    end
  end
end
