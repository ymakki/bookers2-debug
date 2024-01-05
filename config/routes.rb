Rails.application.routes.draw do
  devise_for :users

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

  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
    resources :event_notices, only: [:new, :create]
    get "event_notices" => "event_notices#sent"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  # 検索メソッドの呼び出しパス設定(応用課題5)
  get '/search', to: 'searches#search'

  # ChatsControllerのshowとcreateアクションに対するルートを生成(応用課題8a)
  resources :chats, only: [:show, :create]

  get 'tagsearches/search', to: 'tagsearches#search'

end
