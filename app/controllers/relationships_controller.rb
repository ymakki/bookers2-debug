class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # ユーザーが別のユーザーをフォローする(応用課題4)
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
		redirect_to request.referer
  end

  # ユーザーが別のユーザーのフォローを解除する(応用課題4)
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
		redirect_to request.referer
  end

  # 特定のユーザーがフォローしているユーザー一覧を表示する(応用課題4)
  def followings
    user = User.find(params[:user_id])
		@users = user.followings
  end

  # 特定のユーザーをフォローしているユーザー（フォロワー）の一覧を表示する(応用課題4)
  def followers
    user = User.find(params[:user_id])
		@users = user.followers
  end
end
