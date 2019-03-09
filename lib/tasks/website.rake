
namespace :website do
  desc "TODO"
  task build: :environment do
    Dir["#{Rails.root}/app/views/data/lifts/**.yaml"].each do |datafile| 
      datacontents = File.read(datafile)
      if not datacontents.empty?
        datayaml = YAML.load(datacontents)

        datayaml.each do |item| 
          # byebug
          page_name = "#{item['title'].parameterize}"
          page_category = File.basename(datafile, ".*")

          FileUtils.mkdir_p "#{Rails.root}/app/views/pages/#{page_category}"
          
          open("#{Rails.root}/app/views/pages/#{page_category}/#{page_name}.erb", 'w') do |f|
            content = <<~HEREDOC
              <!--
              title: #{item['title']}
              tags:  #{item['tags']}
              youtube_id: "#{item['youtube_id']}"
              audience: #{item['audience']}
              categories: #{item['categories']}
              permalink: "#{page_category}/#{page_name}"
              layout: post
              -->
            
              <h4>
                #{item[item]}
              </h4>
            
              <iframe width="560" height="315" src="https://www.youtube.com/embed/#{item['youtube_id']}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'

              <p>
                <b><i class="fas fa-user"></i> Audience: <a href="/audience">#{item['audience']}</a></b>
              </p>
              
              
              #{item['content']}
            HEREDOC
            f.puts content
          end
        end
      end
    end
  end
end
