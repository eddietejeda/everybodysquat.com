namespace :build do
   desc "Deploy to production"
   task deploy: :environment do 
    puts "Deploying...."
   end
end