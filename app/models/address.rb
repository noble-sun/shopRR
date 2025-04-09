class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  before_save :set_primary_address_uniqueness_per_user, if: :primary_address_changed_to_true?

  validates_presence_of :street, :number, :neighborhood, :city, :state, :zipcode, :country
  validates :zipcode, numericality: true

  private

  def primary_address_changed_to_true?
    primary_address? && will_save_change_to_primary_address?
  end

  def set_primary_address_uniqueness_per_user
    Address.where(user: user_id, primary_address: true)
      .where.not(id: id)
      .update_all(primary_address: false)
  end
end
