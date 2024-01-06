class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]

  # (↓ 応用課題8a)

  def show
    @user = User.find(params[:id])
    # pluck(:room_id) は、指定されたカラムの値を配列として返す
    # rooms には現在のユーザーが参加している全てのルームの room_id が含まれる
    rooms = current_user.user_rooms.pluck(:room_id)
    # find_by メソッドは、条件に一致する最初のレコードを取得
    # UserRoom モデルから、user_id が @user.id であり、かつ room_id が rooms 配列に含まれているレコードを取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    unless user_rooms.nil?
      # @room は特定のユーザーと現在のユーザーが共有する既存のルーム
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      # 現在のユーザーと特定のユーザーを新しいルームに関連付けるために、UserRoom レコードが2つ作成される
      # 一つは現在のユーザー (current_user) と新しいルーム
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      # もう一つは特定のユーザー (@user) と新しいルームを関連付け
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    # @chatsにはそのルーム内のすべてのチャットが含まれる
    @chats = @room.chats
    # Chatモデルの新しいインスタンスを生成
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    # current_userに関連付けられた Chat モデルの新しいインスタンスを生成
    # chat_paramsによって取得された属性（メッセージの内容やタイムスタンプなど）が新しいチャットにセットされます
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end