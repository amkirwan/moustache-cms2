require "spec_helper"

describe "admin/site_assets/_form.html.haml" do
  include FormHelpers
    
  let(:site) { stub_model(Site, :full_subdomain => "foobar.example.com") }
  let(:site_asset) { stub_model(SiteAsset, :site => site) }
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:current_site, site)
    assign(:site_asset, site_asset)
    assign(:current_user, current_user)
  end
  
  def do_render(label)
    render "admin/site_assets/form", :site_asset => site_asset, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => site_asset })
  end
  
  context "when the site_asset is NEW" do
    before(:each) do
      site_asset.as_new_record
      do_render("Save Media")
    end
    
    it "should render a button to save the new site_asset" do    
      form_new(:action => admin_site_assets_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Media")
      end
    end
    
    it "should render a field to enter the name" do
      form_new(:action => admin_site_assets_path) do |f|
        f.should have_selector("input", :type => "text", :name => "site_asset[name]")
      end
    end
    
    it "should render a field to enter a description" do
      form_new(:action => admin_site_assets_path) do |f|
        f.should have_selector("textarea", :name => "site_asset[description]")
      end
    end
    
    it "should render a field to upload file" do
      form_new(:action => admin_site_assets_path) do |f|
        f.should have_selector("input", :type => "file", :name => "site_asset[source]")
      end
    end
  end
  
  context "when EDITing the site_asset" do
    before(:each) do
      site_asset.stub(:new_record? => false)
    end
    
    it "should render a button to update the site_asset" do
      do_render("Update Asset")
      form_update(:action => admin_site_asset_path(site_asset)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Asset")
      end
    end
    
    it "should render a field with the site_asset name" do
      site_asset.stub(:name => "foobar")
      do_render("Update Asset")
      form_update(:action => admin_site_asset_path(site_asset)) do |f|
        f.should have_selector("input", :type => "text", :value => "foobar")      
      end
    end
    
    it "should render a field with the description" do
      site_asset.stub(:description => "foobar description")
      do_render("Update Asset")
      form_update(:action => admin_site_asset_path(site_asset)) do |f|
        f.should have_selector("textarea", :content => "foobar description")
      end
    end
    
    it "should show the location of the file" do
      site_asset.stub_chain(:source, :url => "/image/path/file.png")
      do_render("Update Asset")
      rendered.should have_selector("a", :content => "http://#{site.full_subdomain}#{site_asset.source.url}")
    end     
  end
end