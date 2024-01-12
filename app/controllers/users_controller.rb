class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  # URLを直接入力された場合ユーザー詳細画面へリダイレクト (ゲストログイン機能を実装しよう)
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # 本の投稿データを代入(応用課題7b)
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  # 特定のユーザーが特定の日に作成した書籍（books）を取得するためのアクション(応用課題9b)
  def daily_posts
    user = User.find(params[:user_id])
    @books = user.books.where(created_at: params[:created_at].to_date.all_day)
    render :daily_posts_form
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  # URLを直接入力された場合ユーザー詳細画面へリダイレクト (ゲストログイン機能を実装しよう)
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

end
