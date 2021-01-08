class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  attachment :profile_image, destroy: false
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # ====================自分がフォローされるユーザーとの関連 ===================================
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollowed_id(フォローされる側)
  has_many :reverse_relationships,  class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 中間テーブルを介して「follower」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :reverse_relationships,  source: :follower

   # ====================自分がフォローしているユーザーとの関連 ===================================
  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローする側)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 中間テーブルを介して「followed」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :relationships, source: :followed

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(followed_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(followed_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end


  validates :name,
  presence: true,
  length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def followed_by?(user)
    relationships.find_by(followed_id: user.id).present?
  end
end

