module Workarea
  class Payment
    module Authorize
      class Affirm
        include OperationImplementation
        include CreditCardOperation

        def complete!
          response = gateway.authorize(tender.checkout_token, tender.payment.id)
          if response.success?
            transaction.response = ActiveMerchant::Billing::Response.new(
              true,
              I18n.t(
                'workarea.affirm.authorize',
                amount: transaction.amount
              ),
              response.body
            )
          else
            transaction.response = ActiveMerchant::Billing::Response.new(
              false,
              I18n.t('workarea.affirm.authorize_failure'),
              response.body
            )
          end
        end

        def cancel!
          return unless transaction.success?

          payment_id = transaction.response.params['id']
          response = gateway.void(payment_id)

          transaction.cancellation = ActiveMerchant::Billing::Response.new(
            true,
            I18n.t('workarea.affirm.void'),
            response.body
          )
        end

        private

        def gateway
          Workarea::Affirm.gateway
        end
      end
    end
  end
end
