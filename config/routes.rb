WIP::Application.routes.draw do

  # Signup
  resources :users, :only => [ :new, :create ]

  # My Account
  resource :account, :only => [ :show, :edit, :update ] do
    member do
      match "change_password" => "accounts#edit_password", :via => :get
      match "change_password" => "accounts#update_password", :via => :put
    end
    collection do
      # Address Book
      resources :addresses
    end
  end

  # Inventory
  resources :inventory, :controller => "inventory_items", :as => :inventory_items, :except => [:show] do
    collection do
      match "in_group/:inventory_group_id" => "inventory_items#index", :as => :group_filtered
      get :pending_delivery
    end
    member do
      post :increment_quantity
      post :decrement_quantity
    end
  end
  resources :inventory_groups, :only => [:create], :defaults => { :format => 'json' }

  # Postings
  resources :postings, :except => [:show] do
    member do
      match :seed_offer # temporary for test approval purposes
    end
  end

  # Orders
  resources :offers do
    resources :orders, :only => [:new, :create] do
      member do
        get :purchase_process
        get :purchase_failed
        get :purchase_cancelled
        get :purchase_complete
      end
    end
  end

  resources :seller_orders, :only => [] do
    member do
      get :mark_shipped
      post :preview_shipped
      post :confirm_shipped
    end
  end

  # Paypal callback
  post 'paypal/ipn_notification', :as => :paypal_ipn_notification

  # Authentication
  match "login" => "sessions#new", :via => :get
  match "login" => "sessions#create", :via => :post
  match "logout" => "sessions#destroy"


  # Search
  scope "search", :as => :search do
    get "postings" => "search#postings", :as => :postings
  end

  # Root
  root :to => 'search#index'

end
