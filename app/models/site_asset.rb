class SiteAsset < MoustacheAsset
  include Mongoid::Document
  include MoustacheCMS2::Taggable

#   attr_accessible :tag_list
  
  # -- Fields ---
  mount_uploader :asset, SiteAssetUploader  

  set_asset_folder :site_assets

  # -- Associations ------
  embedded_in :asset_collection  
  
end
