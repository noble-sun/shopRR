class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_one :cart

  enum :status, {
    pending: "pending",
    awaiting_payment: "awaiting_payment",
    paid: "paid",
    failed: "failed",
    processing: "processing",
    shipped: "shipped",
    canceled: "canceled",
    finished: "finished"
  }
end
