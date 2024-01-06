class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  #グループに参加するために、group_usersという中間テーブルにユーザーとグループの関連を作成する(応用課題8c)
  def create
    group_user = current_user.group_users.new(group_id: params[:group_id])
    group_user.save
    redirect_to request.referer
  end

  #現在ログインしているユーザーが所属しているグループから退会するためのdestroyアクション(応用課題8c)
  def destroy
    group_user = current_user.group_users.find_by(group_id: params[:group_id])
    group_user.destroy
    redirect_to request.referer
  end

end
