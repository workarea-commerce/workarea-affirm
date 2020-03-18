require 'test_helper'

module Workarea
  class AffirmPaymentIntegrationTest < Workarea::TestCase
    def test_auth_capture
      transaction = tender.build_transaction(action: 'authorize')
      Payment::Purchase::Affirm.new(tender, transaction).complete!

      assert(transaction.success?)
      transaction.save!

      capture = Payment::Capture.new(payment: payment)
      capture.allocate_amounts!(total: 5.to_m)
      assert(capture.valid?)
      capture.complete!

      capture_transaction = payment.transactions.detect(&:captures)
      assert(capture_transaction.valid?)
    end

    def test_auth
      transaction = tender.build_transaction(action: 'authorize')
      Payment::Authorize::Affirm.new(tender, transaction).complete!
      assert(transaction.success?, 'expected transaction to be successful')
    end

    def test_purchase
      transaction = tender.build_transaction(action: 'purchase')
      Payment::Purchase::Affirm.new(tender, transaction).complete!
      assert(transaction.success?)
    end

    def test_auth_void
      transaction = tender.build_transaction(action: 'authorize')
      operation = Payment::Authorize::Affirm.new(tender, transaction)
      operation.complete!
      assert(transaction.success?, 'expected transaction to be successful')
      transaction.save!

      operation.cancel!
      void = transaction.cancellation

      assert(void.success?)
    end

    private

    def payment
      @payment ||=
        begin
          profile = create_payment_profile
          create_payment(
            profile_id: profile.id,
            address: {
              first_name: 'Ben',
              last_name: 'Crouse',
              street: '22 s. 3rd st.',
              city: 'Philadelphia',
              region: 'PA',
              postal_code: '19106',
              country: Country['US']
            }
          )
        end
    end

    def tender
      @tender ||=
        begin
          payment.set_address(first_name: 'Ben', last_name: 'Crouse')

          payment.build_affirm(
            checkout_token: '12345',
            details: { foo: 'bar' }
          )

          payment.affirm
        end
    end
  end
end
