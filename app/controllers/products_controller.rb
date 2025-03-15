class ProductsController < ApplicationController
  before_action :authorize_user

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params.expect(:id))
  end

  private

  def authorize_user
    authorize Product
  end
end
