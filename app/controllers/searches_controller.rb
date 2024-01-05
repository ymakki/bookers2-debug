class SearchesController < ApplicationController
  before_action :authenticate_user!

	# ユーザーまたは書籍（Book）モデルに対して、指定された検索条件で検索を実行する(応用課題5)
	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		if @model == 'user'
			@records = User.search_for(@content, @method)
		else
			@records = Book.search_for(@content, @method)
		end
	end
end
