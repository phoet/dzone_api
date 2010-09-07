task :cron => :environment do
  puts "fetching data from dzone at #{Time.now}"
  Item.frontpage_items.each do |item|
    existing_item = Item.first(:conditions => { :id => item.id })
    if existing_item
      puts "found item for id=#{item.id} updating"
      existing_item.update_attributes! item.attributes.delete(:deep_link)
    else  
      puts "adding new item with id=#{item.id}"
      item.deep_link = Item.fetch_deep_link(item.id)
      raise "item=#{item} is not valid" unless item.valid?
      item.save!
    end
  end
end
