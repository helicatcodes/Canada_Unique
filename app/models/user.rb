class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role enum: user = regular student, admin = full access, viewer = read-only parent. MJR
  enum :role, { user: 0, admin: 1, viewer: 2 }

  # A viewer is linked to one child user they shadow. MJR
  belongs_to :linked_user, class_name: "User", optional: true

  has_many :tasks, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :questionnaires, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :messages, through: :chats
  has_one_attached :avatar
  # Gives each user access to their notification inbox via current_user.noticed_notifications. MJR
  has_many :noticed_notifications, as: :recipient, class_name: "Noticed::Notification", dependent: :destroy
end
