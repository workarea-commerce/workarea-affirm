module Workarea
  class Payment
    class Capture
      class Affirm
        include OperationImplementation
        include CreditCardOperation

        def complete!
          response = gateway.capture(charge_id, transaction.amount, tender.payment.id)

          transaction.response = if response.success?
            ActiveMerchant::Billing::Response.new(
              true,
              I18n.t(
                'workarea.affirm.capture',
               amount: transaction.amount
              ),
              response.body
            )
            else
              ActiveMerchant::Billing::Response.new(
                false,
                I18n.t('workarea.affirm.capture_failure'),
                response.body
              )
            end
        end

        def cancel!
          # No op - no cancel functionality available.
        end

        private

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
