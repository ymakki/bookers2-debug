class BookTag < ApplicationRecord
  # tagモデルとbookモデルの中間テーブル(応用課題9d)
  belongs_to :book
  belongs_to :tag
end
