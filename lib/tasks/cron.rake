task :cron => :environment do
  puts "fetching data from dzone at #{Time.now}"
  Item.frontpage_items.each do |item|
    if Item.first(:conditions => { :id => item.id })
      puts "found item for id=#{item.id}"
    else
      raise "item=#{item} is not valid" unless item.valid?
      puts "adding new item with id=#{item.id}"
      item.save
    end
  end
end
