class CreateNotifications < ActiveRecord::Migration[6.1]

  # ↓ 【Rails】通知機能を実装してみよう

  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :notifiable, polymorphic: true, null: false
      # ↑ t.references :userやt.references :notifiableとなっている部分は、
      #   マイグレーションを実行すると適切なカラム名(user_id, notifiable_type・notifiable_id)にそれぞれ変換される
      t.boolean :read, default: false, null: false # 追記
      # ↑ readにも制約を設定しておく
      #   NOT NULL制約とDEFAULT制約を設定するため、default: false, null: falseのオプションを追記

      #   booleanは本来true/falseのいずれかを扱うことを想定して設定するカラム
      #   しかし、マイグレーションファイルに何も指定しない場合、つまり「デフォルトの指定がない」「nullを許容する」という状態だと、
      #   true/false/nilの3つの値が入る形になります。
      #   この問題点としては、今回の場合はreadカラムの値がtrue = 既読, false = 未読, nil = ??という3つの状態が発生してしまう
      t.timestamps
    end
  end
end
