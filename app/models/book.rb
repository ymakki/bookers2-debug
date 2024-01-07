class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # Favoriteモデルのうち、直近の1週間で作成されたいいねを取得(応用課題7a)
  has_many :week_favorites, -> { where(created_at:
  ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..
  (Time.current.at_end_of_day)) }, class_name: 'Favorite'

  # 閲覧データをもつ(応用課題9a)
  has_many :read_counts, dependent: :destroy

  # Book モデルは複数の BookTag モデルと関連付け(応用課題9d)
  has_many :book_tags, dependent: :destroy
  # Book モデルが Tag モデルと多対多の関連付け(応用課題9d)
  has_many :tags, through: :book_tags

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 今日の本の投稿数(応用課題7b)
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  # 前日の本の投稿数(応用課題7b)
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  # 今週の本の投稿数(応用課題7b)
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  # 前週の本の投稿数(応用課題7b)
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  # 特定の日数前に作成されたレコードを取得(応用課題8b)
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }

  # 「特定のユーザーがこのモデルをいいね登録しているかどうか」を確認する(応用課題3)
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # 応用課題9d
  def save_tags(savebook_tags)
    # 現在の Book オブジェクトが持っているタグの名前を current_tags に取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 今回保存されたタグ (savebook_tags) と現在のタグ (current_tags) との差分を計算し、old_tags に代入します。
    # これは削除すべき古いタグを示します
    old_tags = current_tags - savebook_tags
    # 今回保存されたタグ (savebook_tags) と現在のタグ (current_tags) との差分を計算し、new_tags に代入します。
    # これは追加すべき新しいタグを示します。
    new_tags = savebook_tags - current_tags

    # 古いタグをループし、それぞれに対して self.tags.delete を用いて Book オブジェクトから削除しています
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    # 新しいタグをループし、それぞれに対して Tag.find_or_create_by を使用して存在しない場合は新たに作成しています
    new_tags.each do |new_name|
      book_tag = Tag.find_or_create_by(name:new_name)
      # self.tags << book_tag を用いて Book オブジェクトに追加しています
      self.tags << book_tag
    end
  end

  # 2つの引数 content と method を受け取り、指定された条件に基づいて書籍、ユーザーを検索(応用課題5)
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end