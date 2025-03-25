class AlreadyReviewedError < StandardError; end

class ProductReviewsController < ApplicationController
  before_action :set_product_review, only: [ :show, :edit, :update ]

  def reviews
    @product_reviews = ProductReview.where(user: Current.user)
  end

  def new
    @product = Product.find(params.expect(:product_id))
    @product_review = ProductReview.new
  end

  def create
    product = Product.find_by(id: params.expect(:product_id))

    return redirect_to products_path, notice: I18n.t("flash.product.not_found") unless product
    return redirect_to products_path, notice: I18n.t("flash.product_review.owner") if product.user == Current.user

    order = Order.joins(cart: { cart_items: :product }).where(
      user: Current.user,
      cart: { cart_items: { product: product } }
    ).exists?

    if order
      product_review = ProductReview.find_by(user: Current.user, product:)
      raise AlreadyReviewedError if product_review

      product.product_reviews.create!(product_review_params.merge(user: Current.user))
      flash[:notice] = I18n.t("flash.product_review.success")
    else
      flash[:notice] = I18n.t("flash.product_review.not_ordered")
    end

    redirect_to product_path(product)
  rescue AlreadyReviewedError
    redirect_to product_path(product), notice: I18n.t("flash.product_review.already_reviewed")
  rescue ActiveRecord::RecordInvalid => e
    redirect_to product_path(product), notice: I18n.t("flash.product_review.invalid_range")
  rescue => e
    Rails.logger.info e.message
    redirect_to product_path(product), notice: I18n.t("flash.product_review.unexpected")
  end

  def edit
  end

  def update
    if @product_review.update(product_review_params)
      redirect_to product_product_review_path(@product, @product_review),
        notice: I18n.t("flash.product_review.updated.successfully")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_review_params
    params.require(:product_review).permit(:anonymous, :score, :comment)
  end

  def set_product_review
    @product = Product.find(params.expect(:product_id))
    @product_review = ProductReview.find_by(
      id: params.expect(:id),
      product_id: @product,
      user: Current.user
    )

    redirect_to product_path(@product) unless @product_review
  end
end
