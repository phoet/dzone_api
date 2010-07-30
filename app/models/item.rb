require 'hashie'
require 'httpclient'
require 'crack/xml'

class Item < ActiveRecord::Base
  
  validates_presence_of :title, :description, :publishing_date, :categories,
                        :vote_up, :vote_down, :clicks, :comments,
                        :thumbnail, :submitter_name, :submitter_image
  
  def self.frontpage_items(url="http://feeds.dzone.com/dzone/frontpage")
    response = HTTPClient.new.get_content url
    response = response.force_encoding('UTF-8')
    hash = Crack::XML.parse response
    hash['rss']['channel']['item'].map do |i|
       item = Item.new
       item.id = i['dz:linkId'].to_i
       item.title = i['title']
       item.description = i['description']
       item.publishing_date = i['pubDate']
       item.categories = ([] << i['category']).join(', ')
       item.vote_up = i['dz:voteUpCount']
       item.vote_down = i['dz:voteDownCount']
       item.clicks = i['dz:clickCount']
       item.comments = i['dz:commentCount']
       item.thumbnail = i['dz:thumbnail']
       item.submitter_name = i['dz:submitter']['dz:username']
       item.submitter_image = i['dz:submitter']['dz:userimage']
       p real_link(item.id)
       item
    end
  end
  
  def self.real_link(itemid)
    response = HTTPClient.new.get_content "http://www.dzone.com/links/#{itemid}.html"
    response = response.force_encoding('UTF-8')
    return $1 if /<div class="ldTitle"><a .* href="([^"]+).*">/.match(response)
  end
  
end
