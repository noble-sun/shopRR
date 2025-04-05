class CartsController < ApplicationController
  before_action :set_cart

  def show; end

  def add
    product = Product.find_by(id: params[:id])
    quantity = cart_params[:quantity].to_i
    @cart.update_cart_item(product, quantity)

    redirect_to cart_path(@cart) if cart_params[:buy_now].present?
  end

  def remove
    @item = CartItem.find_by(id: params[:id])
    @item.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to cart_path(@cart), notice: "item removed from cart" }
    end
  end

  private

  def set_cart
    @cart = Current.user.active_cart
  end

  def cart_params
    params.permit(:quantity, :id, :buy_now)
  end
end
