class NotificationsController < ApplicationController
  # ↓ 【Rails】通知機能を実装してみよう

  #   通知のコントローラーの中で必要なアクションとしては、未読から既読に更新する処理だけなので、
  #   updateアクションのみです。
  #   ですが、viewは不要なので、アクションの指定はせずにControllerを作成します。

  before_action :authenticate_user!

  # 未読から既読に更新するメソッド
  def update
    # ログインしているユーザーに紐づく通知レコードから、指定のidのレコードを取得します
    notification = current_user.notifications.find(params[:id])
    # 1行目で取得した通知レコードのreadカラムをtrueに更新=既読状態に変更します
    notification.update(read: true)
    # 通知内容の種類に応じたリダイレクト先にリダイレクトします
    redirect_to notification.notifiable_path
  end

end
