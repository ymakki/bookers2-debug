Rails.application.routes.draw do
  devise_for :users

  # sessions_controllerのアクションへ処理をつなげる (ゲストログイン機能を実装しよう)
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    # ユーザー間のフォロー／アンフォロー機能を実現(応用課題4)
    resource :relationships, only: [:create, :destroy]
    # followings アクションを呼び出すルートを設定(応用課題4)
  	get 'followings' => 'relationships#followings', as: 'followings'
    # followers アクションを呼び出すルートを設定(応用課題4)
  	get 'followers' => 'relationships#followers', as: 'followers'
    # daily_posts アクションを呼び出すルートを設定(応用課題9b)
  	get "daily_posts" => "users#daily_posts"
  end

  # groups リソースに対する標準的なRESTfulなアクションを指定(応用課題7c)
  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    # GroupUsersController の中の create と destroy アクションが対応するパスを生成(応用課題8c)
    resource :group_users, only: [:create, :destroy]
    # 新しい通知を作成するフォーム表示 (new) や実際に通知を作成する処理 (create)するルーティングを定義(応用課題9c)
    resources :event_notices, only: [:new, :create]
    # "/event_notices" にアクセスすると EventNoticesController の sent アクションが実行(応用課題9c)
    get "event_notices" => "event_notices#sent"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 検索メソッドの呼び出しパス設定(応用課題5 / 応用課題9d)
  get '/search', to: 'searches#search'

  # ChatsControllerのshowとcreateアクションに対するルートを生成(応用課題8a)
  resources :chats, only: [:show, :create]

end
