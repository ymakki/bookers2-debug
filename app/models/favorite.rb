class Favorite < ApplicationRecord

  # Notifiableモデルを読み込み(【Rails】通知機能を実装してみよう)
  include Notifiable

  belongs_to :user
  belongs_to :book

  # ↓【Rails】通知機能を実装してみよう
  #   Favoriteモデルについては、紐づく通知は1つなので、has_oneで関連付けを設定
  has_one :notification, as: :notifiable, dependent: :destroy

  validates_uniqueness_of :book_id, scope: :user_id

  # ↓【Rails】通知機能を実装してみよう
  #   has_one関連付けの場合は、派生して使えるメソッドがhas_manyと少し違います。
  #   create_notification(user_id: book.user_id)のように、
  #   create_xxxメソッドで関連付けられたレコードを作成できるので注意しましょう
  after_create do
    create_notification(user_id: book.user_id)
  end

  def notification_message
    "投稿した#{book.title}が#{user.name}さんにいいねされました"
  end

  def notification_path
     user_path(user)
  end

end
