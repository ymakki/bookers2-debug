class SearchesController < ApplicationController
  before_action :authenticate_user!

	# ユーザーまたは書籍（Book）モデルに対して、指定された検索条件で検索を実行する(応用課題5)
	def search
		@model = params[:model] #検索モデル
		@content = params[:content] #検索ワード
		@method = params[:method] #検索方法
		if @model == 'user'
			# def self.search_forメソッドで得た情報を@recordsに代入(応用課題5)
			@records = User.search_for(@content, @method)
		elsif @model == 'book'
			# def self.search_forメソッドで得た情報を@recordsに代入(応用課題5)
			@records = Book.search_for(@content, @method)
		# タグ検索を追加(応用課題9d)
		elsif @model == 'tag'
			# def self.search_books_forメソッドで得た情報を@recordsに代入(応用課題9d)
			@records = Tag.search_books_for(@content, @method)
		end
	end
end
