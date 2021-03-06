Rails.application.routes.draw do

# 顧客用
  scope module: 'public' do
    root to: 'homes#top'
    get 'about' => 'homes#about'
  end

  scope module: 'public' do
    get 'customers/mypage' => 'customers#show'
    get 'customers/edit'
    get 'customers/unsubscribe'
    patch 'customers/withdraw' => 'customers#withdraw'
    resources :customers, only: [:update]
  end

   scope module: 'public' do
    get 'items/:id' => 'items#show', as: 'item'
    get 'items' => 'items#index'
  end

  scope module: 'public' do
    resources :addresses, only: [:index, :create, :edit, :update, :destroy]
  end

  scope module: 'public' do
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all', as: 'destroy_all'
    resources :cart_items, only: [:index, :create, :update, :destroy]
  end

  scope module: 'public' do
    post 'orders/confirm' => 'orders#confirm'
    get 'orders/thanks' => 'orders#thanks'
    resources :orders, only: [:new, :index, :show, :create]
  end


# 管理者用
  namespace :admin do
    get '/' => 'homes#top'
  end

  namespace :admin do
    resources :customers, only: [:index, :show, :edit, :update]
  end
  namespace :admin do
    resources :items, only: [:index, :new, :create, :show, :edit, :update]
  end
  namespace :admin do
    resources :genres, only: [:index, :create, :edit, :update]
  end
  namespace :admin do
    resources :orders, only: [:show, :update]
  end
  namespace :admin do
    resources :order_details, only: [:update]
  end

# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
