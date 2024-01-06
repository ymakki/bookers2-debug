class GroupUser < ApplicationRecord
  # User と Group の中間テーブル(応用課題7c)
  belongs_to :user
  belongs_to :group
end
