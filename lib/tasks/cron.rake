task :cron => :environment do
  puts "fetching data from dzone at #{Time.now}"
end
