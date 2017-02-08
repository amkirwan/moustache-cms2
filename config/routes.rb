require File.expand_path(File.join(Rails.root, 'lib', 'moustache_cms2', 'articles_constraint'))

MoustacheCMS2::Application.routes.draw do   

  namespace :admin do

    devise_for :users, :path => '', :controllers => { :sessions => 'admin/sessions', :passwords => 'admin/passwords' } 

    resources :users do
      member do
        get :change_password
        put :update_password
      end
    end
    resources :layouts

    resources :pages do 
      put :sort, :on => :member
      get :new_meta_tag, :on => :collection
      put :preview, :on => :member, :as => :preview
      post :set_state, on: :collection
      resources :meta_tags, :except => [:index, :show] 
      resources :custom_fields, :only => [:new, :destroy]
      resources :page_parts, :except => [:index, :new, :update] 
    end

    resources :authors do
      resources :custom_fields, :only => [:new, :destroy]
    end


    resources :article_collections do
      resources :articles do
        get :new_meta_tag, :on => :collection
        get :new_author, :on => :member
        put :preview, :as => :preview
        resources :meta_tags, :except => [:index, :show] 
        resources :custom_fields, :only => [:new, :destroy]
      end
    end

    get 'articles/new_meta_tag' => 'articles#new_meta_tag', :as => 'articles_new_meta_tag'

    resources :theme_collections do
      resources :theme_assets do
        resources :custom_fields, :only => [:new, :destroy]
      end
    end

    resources :snippets 

    resources :asset_collections do
      resources :site_assets
    end

    resources :sites, :path => 'current_site', :controller => 'current_site' do
      resources :meta_tags, :except => :index 
      resources :domain_names, :except => [:index, :show]
    end
  end

  resource :comments

  get "/admin" => redirect("/admin/pages")

  # filter articles by tag
  get "*page_path/#{MoustacheCMS2::Application.config.filter}/:tag/page", to: redirect('/%{page_path}/#{MoustacheCMS2::Application.config.filter}')
  get "*page_path/#{MoustacheCMS2::Application.config.filter}/:tag/page/:page" => 'cms_site#render_html', as: :articles_filter_page, :constraints => MoustacheCMS2::ArticlesConstraint.new
  get "*page_path/#{MoustacheCMS2::Application.config.filter}/:tag" => 'cms_site#render_html', as: :articles_filter, :constraints => MoustacheCMS2::ArticlesConstraint.new

  # get paginated pages for a collection
  get "*page_path/page", to: redirect('/%{page_path}')
  get "*page_path/page/:page" => 'cms_site#render_html', :as => :articles_page, :constraints => MoustacheCMS2::ArticlesConstraint.new, page: /\d+/
  get "page/:page" => 'cms_site#render_html', :constraints => { page: /\d+/ }

  # find article
  get "*articles/:year/:month/:day/:title" => 'cms_site#render_html', :as => :article_permalink, :constraints => MoustacheCMS2::ArticlesConstraint.new
  get ":year/:month/:day/:title" => 'cms_site#render_html', :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }

  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
  root :to => 'admin/pages#index'
end
