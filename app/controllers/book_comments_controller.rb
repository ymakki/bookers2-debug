class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    #インスタンス変数に変更
    @comment = current_user.book_comments.new(book_comment_params)
    # ↑ 下記2行を省略
    #comment = BookComment.new(book_comment_params)
    #comment.user_id = current_user.id
    @comment.book_id = book.id
    @comment.save
    #redirect記述削除
    #redirect_back(fallback_location: root_path)
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.destroy
    #redirect記述削除
    #redirect_back(fallback_location: root_path)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
