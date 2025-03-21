class ProductReviewsController < ApplicationController
  def review
    product = Product.find_by(id: params.expect(:product_id))

    return redirect_to products_path, notice: I18n.t("flash.product.not_found") unless product
    return redirect_to products_path, notice: I18n.t("flash.product_review.owner") if product.user == Current.user

    order = Order.joins(cart: { cart_items: :product }).where(
      user: Current.user,
      cart: { cart_items: { product: product } }
    ).exists?

    if order
      product.product_reviews.create!(product_review_params)
      flash[:notice] = I18n.t("flash.product_review.success")
    else
      flash[:notice] = I18n.t("flash.product_review.not_ordered")
    end

    redirect_to product_path(product)
  rescue ActiveRecord::RecordInvalid => e
    redirect_to product_path(product), notice: I18n.t("flash.product_review.invalid_range")
  rescue => e
    binding.pry
    Rails.logger.info e.message
    redirect_to product_path(product), notice: I18n.t("flash.product_review.unexpected")
  end

  private

  def product_review_params
    params.require(:product_review).permit(:score)
  end
end
