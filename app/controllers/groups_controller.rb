class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  # 新しい Group インスタンスを作成(応用課題7c)
  def new
    @group =Group.new
  end

  # グループー一覧(応用課題7c)
  def index
    @book = Book.new
    @groups = Group.all
  end

  # グループ詳細(応用課題7c)
  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  # グループ作成メソッド(応用課題7c)
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end

  end

  def edit
  end

  # グループ更新(応用課題7c)
  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end