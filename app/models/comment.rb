class Comment < ApplicationRecord
  belongs_to :product_review

  validates_presence_of :body
end
