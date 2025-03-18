module Seller
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[ show edit update destroy]
    before_action :ensure_seller!

    def index
      @products = Product.with_attached_images.seller_products(Current.user)
    end

    def show; end

    def new
      @product = Product.new
    end

    def edit; end

    def create
      @product = Current.user.products.new(product_params)

      if @product.save
        redirect_to seller_product_path(@product), notice: "Product was successfully created."; nil
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        redirect_to seller_product_path(@product), notice: "Product was successfully updated."; nil
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy!

      redirect_to seller_products_path, status: :see_other, notice: "Product was successfully destroyed."
    end


    private

    def set_product
      @product = Product.with_attached_images.find_by(id: params.expect(:id), user: Current.user)
      redirect_to seller_products_path unless @product
    end

    def product_params
      params.expect(product: [ :active, :name, :description, :quantity, :price, images: [] ])
    end

    def ensure_seller!
      redirect_to root_path unless Current.user.seller?
      authorize Product
    end
  end
end
