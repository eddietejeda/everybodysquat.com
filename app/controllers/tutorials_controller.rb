# frozen_string_literal: true

class TutorialsController < ApplicationController


  def index
    
    # This should not be done as a one-liner! But it was fun, so I did it.
    @tutorial_list = Dir.glob("#{Rails.root}/app/views/tutorials/**/**").map{|e| 
      e.split('tutorials/').last }.map{|e| 
        e.split("/").count == 1 ? "#{e.split("/").first =='index.haml' ? '' : '<h3>'+e.split("/").first.titleize + '</h3>'}": "<a href='/tutorials/#{e}'>#{get_youtube_thumbnail(e)} <p>#{File.basename(e.split("/").last, 'haml' ) .titleize}</a></p>"
      }
          
  end
  
  def show
    
    # byebug
    
    if Dir.glob("#{Rails.root}/app/views/tutorials/**/**").map{|e|
        e.split('tutorials/').last
      }.include?("#{tutorials_params[:exercise]}/#{tutorials_params[:page]}.haml")
      
      render file: "#{Rails.root}/app/views/tutorials/#{tutorials_params[:exercise]}/#{tutorials_params[:page]}"
    else
      render status: 404
    end
    
  end
  
  
  private

  def get_youtube_thumbnail(filename)

    key = File.open("#{Rails.root}/app/views/tutorials/#{filename}",'r').map { |line|  line.split(':').first.strip == 'youtube_id' ? line.split(':').last.gsub!(/"/, '').strip : '' }.join("")    

    return "<img src='https://img.youtube.com/vi/#{key}/hqdefault.jpg'>"
    
  end
    # Only allow a trusted parameter "white list" through.
    def tutorials_params
      params.permit(:exercise, :page)
    end
  
end
