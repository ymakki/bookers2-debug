class Group < ApplicationRecord

  has_one_attached :image
  # groupモデルは User モデルに対して「所有者 (owner)」という関連を持つ(応用課題7c)
  belongs_to :owner, class_name: 'User'
  # groupモデルが GroupUser モデルの複数のレコードと関連付けられている(応用課題7c)
  has_many :group_users, dependent: :destroy
  # Group モデルが GroupUser モデルを通じて User モデルと関連していることを表す(応用課題8c)
  has_many :users, through: :group_users, source: :user

  validates :name, presence: true
  validates :introduction, presence: true

  def get_image
    (image.attached?) ? image : 'no_image.jpg'
  end

  # オブジェクトの所有者を表す owner プロパティが、指定されたユーザー (user) のIDと一致するかどうかを確認(応用課題7c)
  def is_owned_by?(user)
    owner.id == user.id
  end

  #与えられたuserがグループのメンバーであるかどうかを判定するメソッド(応用課題8c)
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

end
