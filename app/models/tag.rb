class Tag < ApplicationRecord
  # 現在のモデルが複数のBookTagモデルと1対多の関係を持ち、外部キーとしてtag_idを使用している(応用課題9d)
  # 外部キーは、親テーブルに存在しない値の登録をエラーにする
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  # Tag インスタンスが  book_tags テーブルを介して、関連する複数の Book インスタンスを取得(応用課題9d)
  has_many :books, through: :book_tags

  # # 2つの引数 content と method を受け取り、指定された条件に基づいたタグを検索(応用課題9d)
  def self.search_books_for(content, method)
    if method == 'perfect'
      tags = Tag.where(name: content)
    elsif method == 'forward'
      tags = Tag.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      tags = Tag.where('name LIKE ?', '%' + content)
    else
      tags = Tag.where('name LIKE ?', '%' + content + '%')
    end
    # injectメソッドは各要素に対してブロックを実行し、その結果を累積していくメソッドです。
    # 初期値として空の配列[]を指定しています
    # ブロック内では、resultは現在までの累積結果を表し、tagはtagsの各要素を表します。
    # tag.booksが、tagが持つbooksの配列を表し、それをresultに加えて新たな累積結果とします。
    # 各tagのbooksをすべて集めた配列が最終的な戻り値となります
    return tags.inject(init = []) {|result, tag| result + tag.books}

  end
end
