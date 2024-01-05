class Relationship < ApplicationRecord
  # モデルが「フォロワー」を持つことを示しています(応用課題4)
  belongs_to :follower, class_name: "User"
  # モデルが「フォローされているユーザー」を持つことを示しています(応用課題4)
  belongs_to :followed, class_name: "User"
end