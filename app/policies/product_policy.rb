class ProductPolicy < ApplicationPolicy
  def create? = user.seller?
  def update? = user.seller?
  def destroy? = user.seller?
  def index? = true
  def show? = true
end
