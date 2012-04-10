def set_meta_tags(type)
    [ 
      FactoryGirl.build(:meta_tag, name: 'title', content: "title #{type}"),
      FactoryGirl.build(:meta_tag, name: 'keywords', content: "keywords #{type}"),
      FactoryGirl.build(:meta_tag, name: 'description', content: "description #{type}")
    ]
end

def assign_created_updated_by(obj, relation)
  obj.created_by = created_by = FactoryGirl.create(:user, site_id: obj.site_id)
  obj.updated_by = updated_by = FactoryGirl.create(:user, site_id: obj.site_id)
  created_by.send(relation.to_s + '_created') << obj
  updated_by.send(relation.to_s + '_updated') << obj
end

def page_associations(page)
  page.layout = FactoryGirl.build(:layout, site_id: page.site_id)
  page.current_state = FactoryGirl.build(:current_state)
  page.editors = [ FactoryGirl.build(:user, site_id: page.site_id) ]
  page.page_parts [ FactoryGirl.build(:page_part) ]
  assign_created_updated_by(page, :pages)
end

def article_associations(article) 
  article.layout = FactoryGirl.build(:layout, site_id: article.site_id)
  article.current_state = FactoryGirl.build(:current_state)
  article.authors = [ FactoryGirl.build(:author, site_id: article.site_id) ] 
  article.article_collection = FactoryGirl.build(:article_collection)
end

def assign_asset_collection(asset_collection)
  assign_created_updated_by(asset_collection, :asset_collections)
end

FactoryGirl.define do
  factory :meta_tag do 
    name "title"
    content "foobar"
  end

  factory :site do 
    sequence(:name) { |n| "name_#{n}" }
    sequence(:subdomain)  { |n| "foobar_#{n}" }
    meta_tags { set_meta_tags('site') }
    default_domain  "com" 
  end

  factory :user do
    sequence(:username) { |n| "foo_#{n}"}
    firstname "foo" 
    lastname  "handlebar" 
    sequence(:email) { |n| "foo_#{n}@example.com" }
    role "admin" 
    site 
    password "foobar7"
  end

  factory :admin, :parent => :user do 
    role "admin" 
  end

  factory :designer, :parent => :user do
    role "designer"
  end

  factory :editor, :parent => :user do 
    role "editor"
  end

  factory :filter do 
    name "filter"
  end

  factory :layout do 
    association :site, strategy: :build
    sequence(:name) { |n| "layout_#{n}" }
    content "Hello, World!"
    after_build { |layout| assign_created_updated_by(layout, :layouts) }
  end

  factory :current_state do
    name "published"
    time DateTime.new
  end

  factory :snippet do 
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
    content "snippet content"
    filter_name "snippet filter"
    after_build { |snippet| assign_created_updated_by(snippet, :snippets) }
  end

  factory :page_type do 
    name "page_type"
  end

  factory :page_part do
    sequence(:name) { |n| "page_part_#{n}" }
    content "Page Part Hello, World!"
    filter_name "filter"
  end

  factory :page do 
    association :site, strategy: :build
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
    tags "page"
    meta_tags { set_meta_tags('page') }
    after_build { |page| page_associations(page) }
  end

  factory :parent_page, :parent => :page do
    parent
    sequence(:title) { |n| "parent_title_#{n}" }
    slug 
    sequence(:full_path) { |n| "parent_full_path_#{n}" }
    sequence(:breadcrumb) { |n| "parent_breadcrumb_#{n}" }
  end     

  factory :author do 
    association :site, strategy: :build
    prefix "prefix"
    firstname "foobar"
    lastname "baz"
    profile "this is the author profile"
    image { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    after_build { |author| assign_created_updated_by(author, :author) }
  end

  factory :article_collection do 
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
    editors {[ FactoryGirl.build(:user) ]}
    after_build { |article_collection| assign_created_updated_by(article_collection, :article_collections) }
  end

  factory :article do 
    association :site, strategy: :build
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    tags "article"
    layout_id { FactoryGirl.build(:layout).id }
    current_state { FactoryGirl.build(:current_state) }
    meta_tags { set_meta_tags('article') }
    content "article content"
    authors { [FactoryGirl.build(:user)] }
    filter_name "published"
    article_collection { FactoryGirl.build(:article_collection) }
    after_build { |article| assign_created_updated_by(article, :articles) }
  end

  factory :asset_collection do 
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
    site_assets { [ FactoryGirl.build(:site_asset) ] }
    after_build { |asset_collection| assign_created_updated_by(asset_collection, :asset_collections) }
  end

  factory :site_asset do 
    name "asset_name"
    content_type "content_type"
    asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    width 200
    height 200
    file_size 200
  end

  factory :custom_field do 
    sequence(:name) { |n| "name_#{n}" }
    content "tag attribute value"
  end

  factory :theme_asset do 
    name "asset_name"
    content_type "content_type"
    asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    width 200
    height 200
    file_size 200
    creator_id { FactoryGirl.build(:user).id }
    updator_id { FactoryGirl.build(:user).id }
  end

  factory :theme_collection do 
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
    after_build { |theme_collection| assign_created_updated_by(theme_collection, :theme_collections) }
  end
end
