require 'hashie'
require 'httpclient'
require 'crack/xml'

class Item < ActiveRecord::Base
  
  def self.parse_from_url(url="http://feeds.dzone.com/dzone/frontpage")
    response = HTTPClient.new.get_content url
    response = response.force_encoding('UTF-8')
    hash = Crack::XML.parse response
    hash['rss']['channel']['item'].map do |i|
       item = Item.new
       item.title = i['title']
       item.description = i['description']
       item.publishing_date = i['pubDate']
       item.categories = ([] << i['category']).join(', ')
       item.link_id = i['dz:linkId']
       item.vote_up = i['dz:voteUpCount']
       item.vote_down = i['dz:voteDownCount']
       item.clicks = i['dz:clickCount']
       item.comments = i['dz:commentCount']
       item.thumbnail = i['dz:thumbnail']
       item.submitter_name = i['dz:submitter']['dz:username']
       item.submitter_image = i['dz:submitter']['dz:userimage']
       item
    end
  end
  
end
