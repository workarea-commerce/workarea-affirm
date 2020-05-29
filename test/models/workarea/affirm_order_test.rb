require 'test_helper'

module Workarea
  class AffirmOrderTest < TestCase
    def test_affirm_available?
      order = Order.new
      order.items.build(
        fulfillment: 'shipping',
        product_attributes: { 'affirm_available' => true }
      )
      assert(order.affirm_available?)

      order.items.build(
        fulfillment: 'download',
        product_attributes: { 'affirm_available' => false }
      )
      refute(order.affirm_available?)

      order = Order.new
      order.items.build(
        fulfillment: 'shipping',
        product_attributes: { 'affirm_available' => false }
      )
      refute(order.affirm_available?)
    end
  end
end
