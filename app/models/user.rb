class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :questionnaires, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats
  # Gives each user access to their notification inbox via current_user.noticed_notifications. MJR
  has_many :noticed_notifications, as: :recipient, class_name: "Noticed::Notification", dependent: :destroy
end
