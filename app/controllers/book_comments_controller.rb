class BookCommentsController < ApplicationController

  # 本に対するコメントを作成する(応用課題3)
  def create
    book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = book.id
    @comment.save
  end

  # 本に関連するコメントを削除する(応用課題3)
  def destroy
    @comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
    @comment.destroy
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
