module Seller
  class SellersController < ApplicationController
    def enable
      user = Current.user

      redirect_to seller_products_path, notice: "Parabéns! Agora você pode cadastrar seus produtos!"
    end

  end
end
