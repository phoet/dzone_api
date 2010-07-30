class ItemsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@items = Item.all(:limit => 10, :order => 'id DESC'))
  end
  
end
