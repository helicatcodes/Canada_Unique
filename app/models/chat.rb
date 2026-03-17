class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages # added that a chat can have many messages. NVD
end
