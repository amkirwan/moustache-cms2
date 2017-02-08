class MoustacheCollection
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include MoustacheCMS2::Siteable
  include MoustacheCMS2::FriendlyFilename
  include MoustacheCMS2::Collectable

  # attr_accessible :name

  # -- Field --
  field :name

  # -- Index -----
  index :name => 1

  # -- Validations ---------------
  validates :name,
            :presence => true,
            :uniqueness => { :scope => :site_id }
            
  class Metal < MoustacheCollection
    include MoustacheCMS2::CreatedUpdatedBy
  end
   
end
