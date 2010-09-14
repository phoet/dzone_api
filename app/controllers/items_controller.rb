class ItemsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  def index
    limit = params[:limit] || 25
    respond_with(@items = Item.all(:limit => limit.to_i, :order => 'id DESC'))
  end
  
  def vote
    item = Item.find(params[:id])
    item.vote(params[:user], params[:pass])
    render :nothing => true
  end
  
end
