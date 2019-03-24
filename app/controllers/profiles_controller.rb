# frozen_string_literal: true
require 'digest'


class ProfilesController < ApplicationController
  # helper_method :filtering_params
  # validate :reserved_username


  def settings
    @user = User.where("username = '#{params[:username]}'").first
    
    @user_email_hash = Digest::MD5.hexdigest(@user.email)
    
    unless @user
      render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
    
  end

  def goals
  end
  
  def charts

        
  end
  
  
  def charts_json
    
    color_list = [
      '#11144c',
      '#3a9679',
      '#e16262',
      '#e3c4a8',
      '#4592af',
      '#226089',
      '#b7fbff',
      '#fff6be',
      '#ffe0a3',
      '#ffa1ac',
      '#fabc60'

    ]
    
    
    
    datasets = current_user.routine.exercises.distinct.map do |e|
      {
        label: e.name,
        data: Workout.select("created_at AS x, results->>'#{e.id}' AS y").where("user_id = :user_id", {user_id: 1}).order(:created_at).map{|f|
          { "x" => f["x"].strftime('%F %T'), "y" => f["y"] } 
        },
        fill: false,
        backgroundColor: color_list.pop,
        borderColor: color_list.pop
        
      }
    end
    
    
    response = {
      type: 'line',
      data: {
        datasets: datasets
      },
      options: {
        responsive: true,
        title: {
          display: true,
          text: "Progress"
        },
        scales: {
          xAxes: [{
              type: "time",
              time: {
                format: "YYYY-MM-DD",
                tooltipFormat: 'lll'
              },
              scaleLabel: {
                display: true,
                labelString: 'Date'
              }
          }],
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Weight'
            }
          }]
        }
      } 
    }
    
    
    render :json => response
    
  end    
  
  

    

  def timeline
    
  end

  def workouts
    offset = profile_params[:page].to_i * 10
    
    @workouts = current_user.workouts.order(id: :desc).offset(offset).limit(10)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @workouts.as_json  }
    end
  end
  
  private
    
  def profile_params
    params.permit(:page)    
  end

      


end
