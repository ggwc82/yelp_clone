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

  has_attached_file :image,
                    :styles => { :medium => "300x300>",
                    :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
                    
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

end
