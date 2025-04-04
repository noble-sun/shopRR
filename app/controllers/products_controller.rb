class ProductsController < ApplicationController
  before_action :authorize_user

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params.expect(:id))
    @reviews = ProductReview.ordered_reviews_by_user(@product)
    @rating = @reviews.average(:score).to_f
    @user_review = Current.user.product_reviews.find_by(product: @product) || @product.product_reviews.new
  end

  private

  def authorize_user
    authorize Product
  end
end
