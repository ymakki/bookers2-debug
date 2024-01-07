class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    # ユーザーが閲覧した履歴を保存する(応用課題9a)
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.read_counts.create(book_id: @book.id)
    end
    @book_comment = BookComment.new
  end

  def index
    # params[:sort] が存在する場合(応用課題8d)
    if params[:sort]
      # Book モデルのすべてのレコードを取得し、指定されたソート順で並べ替え(応用課題8d)
      @books = Book.all.order(params[:sort])
    else
      # @booksにはお気に入りの数が多い順にソートされた本が代入(応用課題7a)
      to  = Time.current.at_end_of_day
      from  = (to - 6.day).at_beginning_of_day
      @books = Book.all.sort {|a,b|
        b.favorites.where(created_at: from...to).size <=>
        a.favorites.where(created_at: from...to).size
      }
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    # HTTPリクエストから取得されたparamsハッシュからbookというキーを介してtag_nameの値を取得し、
    # それをコンマで区切って配列に変換しています(応用課題9d)
    tag_list = params[:book][:tag_name].split(',')
    if @book.save
      # tag_listを引数にsave_tagsメソッドを呼び出し(応用課題9d)
      @book.save_tags(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    # rateカラムを保存できるようにデータ操作を許可(応用課題7d)
    params.require(:book).permit(:title, :body, :rate)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
