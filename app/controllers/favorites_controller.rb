class FavoritesController < ApplicationController

  before_action :authenticate_user!

  def create
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: book.id)
    @favorite.save
    render 'replace_favorite'
  end

  def destroy
    book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: book.id)
    @favorite.destroy
    render 'replace_favorite'
  end
end
