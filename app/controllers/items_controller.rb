class ItemsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  def index
    respond_with(@items = Item.all(:limit => 25, :order => 'id DESC'))
  end
  
  def vote
    item = Item.find(params[:id])
    item.vote(params[:user], params[:pass])
    render :nothing => true
  end
  
end
