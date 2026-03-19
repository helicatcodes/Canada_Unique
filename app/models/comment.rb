class Comment < ApplicationRecord
  belongs_to :photo
  belongs_to :user
  # [HW] Prevent blank comments from being saved
  validates :text, presence: true
end
