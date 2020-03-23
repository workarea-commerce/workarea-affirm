module Workarea
  class Payment
    module Purchase
      class Affirm
        include OperationImplementation
        include CreditCardOperation

        def complete!
          auth_response = gateway.authorize(tender.checkout_token, tender.payment.id)
          return auth_error(auth_response.body) unless auth_response.success?

          response = gateway.capture(auth_response.body['id'], transaction.amount, tender.payment.id)

          if response.success?
            transaction.response = ActiveMerchant::Billing::Response.new(
              true,
              I18n.t(
                'workarea.affirm.purchase',
                amount: transaction.amount
              ),
              auth_response.body
            )
          else
            transaction.response = ActiveMerchant::Billing::Response.new(
              false,
              I18n.t('workarea.affirm.purchase_capture_failure'),
              response.body
            )
          end
        end

        def cancel!
          # No op - no cancel functionality available.
        end

        private

        def auth_error(details)
          transaction.response = ActiveMerchant::Billing::Response.new(
            false,
            I18n.t('workarea.affirm.purchase_authorize_failure'),
            details
          )
        end

        def charge_id
          transaction.reference.response.params['id']
        end

        def gateway
          Workarea::Affirm.gateway
        end
      end
    end
  end
end
