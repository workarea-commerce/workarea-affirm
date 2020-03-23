module Workarea
  module Affirm
    class Update
      attr_reader :checkout, :checkout_token

      def initialize(checkout, checkout_token)
        @checkout = checkout
        @checkout_token = checkout_token
      end

      def details
        @details ||= Affirm.gateway.get_checkout(checkout_token)
      end

      def apply
        payment = checkout.payment
        order = checkout.order

        payment.set_affirm(
          checkout_token: checkout_token,
          details: details.body
        )
        payment.adjust_tender_amounts(order.total_price)

        order.save && payment.save
      end
    end
  end
end
