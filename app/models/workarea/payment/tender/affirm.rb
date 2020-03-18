module Workarea
  class Payment
    class Tender
      class Affirm < Tender
        field :checkout_token, type: String
        field :details, type: Hash

        def slug
          :affirm
        end

        def set_amount(amount)
          self.amount = amount
        end
      end
    end
  end
end
