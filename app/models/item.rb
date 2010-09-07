require 'hashie'
require 'httpclient'
require 'crack/xml'

class Item < ActiveRecord::Base
  
  validates_presence_of :title, :description, :publishing_date, :categories,
                        :vote_up, :vote_down, :clicks, :comments,
                        :thumbnail, :submitter_name, :submitter_image, :deep_link
  
  def vote(user, pass)
    Item.vote(user, pass,id)
  end
  
  def self.frontpage_items(url="http://feeds.dzone.com/dzone/frontpage")
    response = HTTPClient.new.get_content url
    response = response.force_encoding('UTF-8') if response.respond_to?(:force_encoding)
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
       item
    end
  end
  
  def self.fetch_deep_link(itemid)
    p "deep linking itemid=#{itemid}"
    response = HTTPClient.new.get_content "http://www.dzone.com/links/#{itemid}.html"
    response = response.force_encoding('UTF-8') if response.respond_to?(:force_encoding)
    return $1 if /<div class="ldTitle"><a .* href="([^"]+).*">/.match(response)
    raise "could not find the deep link of item=#{itemid}"
  end
  
  def self.vote(user, pass, itemid, type=:up)
    puts "jipdidipppi #{user} #{itemid}"
    client = HTTPClient.new
    client.set_cookie_store("#{Rails.root}/tmp/cookie.dat")
    client.get "http://www.dzone.com/links/j_acegi_security_check?j_username=#{user}&j_password=#{pass}&_acegi_security_remember_me=on"
    
    header = {
    'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language'=>'en-us,en;q=0.5',
    'Accept-Encoding'=>'gzip,deflate',
    'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
    'Content-Type'=>'text/plain; charset=UTF-8',
    }

    post = {
    'callCount'=>'1',
    'c0-scriptName'=>'LinkManager',
    'c0-methodName'=>'incrementVoteCount', # use 'decrementVoteCount' for unvote
    'c0-param0'=>"number:#{itemid}",
    'c0-param1'=>"number:#{type == :up ? 1 : 0}",
    'c0-param2'=>'boolean:false',
    'xml'=>'true'
    }
    client.post('http://www.dzone.com/links/dwr/exec/LinkManager.incrementVoteCount.dwr', post, header)
  end
end
