class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image
end

# [HW] added dependent: :destroy to comments & likes associations, which tells Rails to delete a photo's comments and likes first before deleting the photo itself
