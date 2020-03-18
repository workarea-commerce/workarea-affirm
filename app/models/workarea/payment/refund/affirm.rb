module Workarea
  class Payment
    class Refund
      class Affirm
        include OperationImplementation
        include CreditCardOperation

        def complete!
          response = gateway.refund(charge_id, transaction.amount)

          transaction.response = if response.success?
           ActiveMerchant::Billing::Response.new(
             true,
             I18n.t(
               'workarea.affirm.refund',
               amount: transaction.amount
             ),
             response.body
           )
          else
           ActiveMerchant::Billing::Response.new(
             false,
             I18n.t('workarea.affirm.refund_failure'),
             response.body
           )
          end
        end

        def cancel!
          # No op - no cancel functionality available.
        end

        private

        def charge_id
          tran = tender.transactions.detect { |t| t.success? & %w[authorize purchase].include?(t.action) }
          tran.response.params['id']
        end

        def gateway
          Workarea::Affirm.gateway
        end
      end
    end
  end
end
