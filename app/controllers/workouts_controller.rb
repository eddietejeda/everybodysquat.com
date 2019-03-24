# frozen_string_literal: true

class WorkoutsController < ApplicationController
  # helper_method :filtering_params

  def index
    offset = profile_params[:page].to_i * 10
    
    @workouts = current_user.workouts.order(id: :desc).offset(offset).limit(10)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @workouts.as_json  }
    end
  end

  def create
    if current_user.routine_id > 0
    
      @workout = current_user.active_workout || current_user.create_workout
      fresh_when(@workout)

      unless @workout
        flash[:alert] = 'Cannot create a new task'
      end
      redirect_to "/workouts/#{@workout.id}/edit" #edit_workout_path(@workout)
      
    else
      flash[:alert] = 'Please select a routine'
      redirect_to '/routines'
    end
    
  end

  def resume
    if current_user.active_workout
      redirect_to "/workouts/#{current_user.active_workout.id}/edit"
    else
      redirect_to "/#{current_user.username}/workouts"
    end
  end
  
  def update
    Rails.logger.info{ workout_params[:title] }
    if Workout.find(params[:id]).update(workout_params.to_h)
      head :ok
    else
      flash[:alert] = 'Workout title cannot be blank'
    end
  end
  
  
  def show
    @workout = Workout.find(params[:id])
  end

  def edit
    @workout = Workout.find(params[:id])
  end

  
  def stop
    if current_user.has_active_workout?
      w = current_user.active_workout


      results = current_user.workouts.last.unique_exercises.map do |e|
        {"#{e.id}".to_i => Sett.where(workout_id: w.id, exercise_id: e.id).maximum('weight')}
      end
            
      w.results = results.as_json

      w.completed_at = DateTime.now
      w.active = false
      w.save!
    end
    cookies.delete :restTime
    redirect_to "/workouts/#{w.id}/edit"
  end



  private

  def workout_params
    params.require(:workout).permit(:id, :title, :completed, :completed_filter)
  end


  def profile_params
    params.permit(:page)    
  end


end
