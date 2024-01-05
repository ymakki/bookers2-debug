class FavoritesController < ApplicationController
  # ユーザーが本をいいねする(応用課題3)
  def create
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: book.id)
    @favorite.save
    render 'replace_btn'
  end

  # ユーザーが本のいいねを解除する(応用課題3)
  def destroy
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    @favorite.destroy
    render 'replace_btn'
  end
end