module Workarea
  class Storefront::AffirmController < Storefront::ApplicationController
    include Storefront::CurrentCheckout

    before_action :validate_checkout

    def complete
      check_inventory || return
      current_order.user_id = current_user.try(:id)

      Workarea::Affirm::Update.new(
        current_checkout,
        params[:checkout_token]
      ).apply

      Pricing.perform(current_order, current_shipping)
      current_checkout.payment.adjust_tender_amounts(current_order.total_price)

      if current_checkout.place_order && current_checkout.payment.affirm.details['total'] == current_checkout.payment.affirm.amount.cents
        completed_place_order
      else
        incomplete_place_order
      end
    end

    private

    def completed_place_order
      Storefront::OrderMailer.confirmation(current_order.id).deliver_later
      self.completed_order = current_order
      clear_current_order

      flash[:success] = t('workarea.storefront.flash_messages.order_placed')
      redirect_to finished_checkout_destination
    end

    def incomplete_place_order
      flash[:error] = t('workarea.storefront.flash_messages.order_place_error')

      payment = current_checkout.payment
      payment.clear_affirm

      redirect_to checkout_payment_path
    end

    def finished_checkout_destination
      if current_admin.present? && current_admin.orders_access?
        admin.order_path(completed_order)
      else
        checkout_confirmation_path
      end
    end
  end
end
