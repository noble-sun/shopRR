class ProductsController < ApplicationController
  before_action :authorize_user

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params.expect(:id))
    @reviews = ProductReview.ordered_reviews_by_user(@product)
    @rating = @reviews.average(:score).to_f
  end

  private

  def authorize_user
    authorize Product
  end
end
