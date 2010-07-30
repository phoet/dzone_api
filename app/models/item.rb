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
       item.deep_link = deep_link(item.id)
       item
    end
  end
  
  def self.deep_link(itemid)
    p "deep linking itemid=#{itemid}"
    response = HTTPClient.new.get_content "http://www.dzone.com/links/#{itemid}.html"
    response = response.force_encoding('UTF-8')
    return $1 if /<div class="ldTitle"><a .* href="([^"]+).*">/.match(response)
    raise "could not find the deep link of item=#{itemid}"
  end
  
  def self.doit
    
    header = {
    'User-Agent'=>'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100722 Firefox/3.6.8',
    'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language'=>'en-us,en;q=0.5',
    'Accept-Encoding'=>'gzip,deflate',
    'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
    'Keep-Alive'=>'115',
    'Connection'=>'keep-alive',
    'Content-Type'=>'text/plain; charset=UTF-8',
    'Referer'=>'http://www.dzone.com/links/practical_php_patterns_two_step_view.html',
    'Content-Length'=>'172',
    'Cookie'=>'dzexpresstoken=MDAwMDAwMDA1MDIxMWY1ZGE4MTk1; __utma=62263603.2134729345.1257172860.1280498258.1280501526.122; __utmz=62263603.1280503674.122.7.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=dzone%20vote%20script; __qca=P0-1700932613-1257172860085; __auc=3ce01cb5124e2a08e6960a63ecc; SESS374e8db54ec3033c25a586b1d093b1d1=calodv74ft496gtacqb64ne105; __utmb=62263603.17.9.1280501526339; __asc=f4841ccd12a23e6481e0cb60e5d; ACEGI_SECURITY_HASHED_REMEMBER_ME_COOKIE=phoet!v3!972954168; JSESSIONID=baaIMi98JbU5vhEOIjDOs; has_js=1; __utmc=62263603',
    'Pragma'=>'no-cache',
    'Cache-Control'=>'no-cache'
    }

    post = {
    'callCount'=>'1',
    'c0-scriptName'=>'LinkManager',
    'c0-methodName'=>'incrementVoteCount',
    'c0-id'=>'9155_1280506063010',
    'c0-param0'=>'number:457037',
    'c0-param1'=>'number:1',
    'c0-param2'=>'boolean:false',
    'xml'=>'true'
    }
    client.post('http://www.dzone.com/links/dwr/exec/LinkManager.incrementVoteCount.dwr', post, header)
    
  end
  
  def login
    HTTPClient.new.get_content "http://www.dzone.com/links/j_acegi_security_check?j_username=#{user}&j_password=#{pass}&_acegi_security_remember_me=on"
  end
  
end
