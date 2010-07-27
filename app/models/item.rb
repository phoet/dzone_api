require 'hashie'
require 'httpclient'
require 'crack/xml'

class Item < ActiveRecord::Base
  
  def self.parse_from_url(url="http://feeds.dzone.com/dzone/frontpage")
    response = HTTPClient.new.get_content url
    response = response.force_encoding('UTF-8')
    hash = Crack::XML.parse response
    mash = Hashie::Mash.new hash
  end
  
end
