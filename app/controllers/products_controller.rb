class ProductsController < ApplicationController
  before_action :authorize_user

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params.expect(:id))
    @rating =
      if @product.product_reviews.present?
        @product.product_reviews.pluck(:score).sum / @product.product_reviews.count
      end
  end

  private

  def authorize_user
    authorize Product
  end
end
