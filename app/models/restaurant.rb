class Restaurant < ActiveRecord::Base

  belongs_to :user
  has_many :reviews,
    -> { extending WithUserAssociationExtension },
    dependent: :destroy

  validates :name, length: {minimum: 3}, uniqueness: true

  def average_rating
    return 'N/A' if reviews.none?
     reviews.inject(0) {|memo, review| memo + review.rating} / reviews.size
     # reviews.average(:rating) - doesn't work. Returns a big number or something
  end

end
