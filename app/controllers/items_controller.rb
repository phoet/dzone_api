class ItemsController < ApplicationController
  
  respond_to :xml, :json
  
  def index
    respond_with(@items = Item.all)
  end
  
end
