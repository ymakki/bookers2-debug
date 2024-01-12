class Users::SessionsController < Devise::SessionsController

  # ゲストログイン用の独自のメソッド(ゲストログイン機能を実装しよう)
  # ※Deviseのsessions_controller.rbの機能を継承して実装
  def guest_sign_in
    user = User.guest
    # ↑ Userのguestメソッド呼び出し
    sign_in user
    # ↑ ゲストユーザーをログイン状態にします
    redirect_to user_path(user), notice: "guestuserでログインしました。"
    # ↑ ゲストユーザーの詳細ページへと遷移させます
  end
end