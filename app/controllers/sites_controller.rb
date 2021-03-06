class SitesController < ApplicationController
  before_filter :visitor_node
  before_filter :remove_methods, :only => [:new, :create, :destroy]
  before_filter :find_site, :except => [:index, :create, :new]
  before_filter :check_is_admin
  layout :admin_layout

  def index
    secure!(Site) do
      @sites = Site.paginate(:all, :order => 'host', :per_page => 20, :page => params[:page])
    end
    respond_to do |format|
      format.html # index.erb
      format.xml  { render :xml => @sites }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml  { render :xml => @site }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js   { render :partial => 'sites/form', :layout => false }
    end
  end

  def update
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to site_path(@site) }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js
        format.xml  { render :xml => @site.errors }
      end
    end
  end

  def clear_cache
    @site.clear_cache

    @clear_cache_message = _("Cache cleared.")
  end

  protected
    def visitor_node
      @node = visitor.contact
    end

    def remove_methods
      raise ActiveRecord::RecordNotFound
    end

    def find_site
      @site = secure!(Site) { Site.find(params[:id])}
    end

end
