class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # ↓【Rails】通知機能を実装してみよう
  has_many :notifications, dependent: :destroy

  # DM機能には、Userモデル、Entryモデル、Roomモデル、Messageモデルの4つが必要(応用課題8a)
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  # 閲覧データをもつ(応用課題9a)
  has_many :read_counts, dependent: :destroy

  # UserModel は GroupUser モデル(中間テーブル)と複数の関連を持つ(応用課題7c)
  has_many :group_users, dependent: :destroy

  has_many :groups, through: :group_users

  # 自分がフォローされる（被フォロー）側の関係性(応用課題4)
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人(応用課題4)
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性(応用課題4)
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人(応用課題4)
  has_many :followings, through: :relationships, source: :followed

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # 引数として渡されたユーザー（user）をフォローする(応用課題4)
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # 引数として渡されたユーザー（user）のフォローを解除する(応用課題4)
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # 引数として渡されたユーザー（user）がフォローされているかどうかを判定(応用課題4)
  def following?(user)
    followings.include?(user)
  end

  # 2つの引数 content と method を受け取り、指定された条件に基づいてユーザーを検索(応用課題5)
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  # guestメソッド(ゲストログイン機能を実装しよう)
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
    # ↑ find_or_create_byは、データの検索と作成を自動的に判断して処理を行う、Railsのメソッド
    #   具体的には、find_or_create_by(条件)の条件としたデータが存在するかどうかを判断した上で
    #   ・存在する場合には、そのデータを返す
    #   ・存在しない場合は、新規作成する
    #   という判断と処理を行います。

    # また、find_or_create_by!の「!」を付与することで、
    # 処理がうまくいかなかった場合にエラーが発生するようになり、結果不具合を検知しやすくなります
      user.password = SecureRandom.urlsafe_base64
      # ↑ SecureRandom.urlsafe_base64は、ランダムな文字列を生成するRubyのメソッドの一種
      user.name = "guestuser"
    end
  end

  # ゲストユーザーであるかの判別メソッド(ゲストログイン機能を実装しよう)
  def guest_user?
    email == GUEST_USER_EMAIL
  end

end


