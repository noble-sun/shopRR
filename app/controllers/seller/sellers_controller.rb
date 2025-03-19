module Seller
  class SellersController < ApplicationController
    def enable
      user = Current.user.seller!

      redirect_to seller_products_path, notice: I18n.t("flash.seller.enable.success")
    rescue => e
      Rails.logger.info e.message
      redirect_to root_path, notice: I18n.t("flash.seller.enable.failure")
    end
  end
end
