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

  def show
    @workout = Workout.find(params[:id])
  end

  def edit
    @workout = Workout.find(params[:id])
  end

  def start
    if current_user.routine_id > 0
    
      @workout = current_user.active_workout || current_user.create_workout
      fresh_when(@workout)

      unless @workout
        flash[:alert] = 'Cannot create a new task'
      end
      redirect_to edit_workout_path(@workout) #"/workouts/#{@workout.id}/edit" #edit_workout_path(@workout)
      
    else
      flash[:alert] = 'Please select a routine'
      redirect_to routines_path
    end
    
  end

  def resume
    if current_user.active_workout
      redirect_to edit_workout_path(current_user.active_workout.id) #"/workouts/#{current_user.active_workout.id}/edit"
    else
      redirect_to workouts_path #"/#{current_user.username}/workouts"
    end
  end

  
  def stop
    workout = current_user.active_workout
    current_user.complete_workout(workout)
    cookies.delete :restTime
    redirect_to edit_workout_path(workout)
  end

  
  def update
    Rails.logger.info{ workout_params[:title] }
    if Workout.find(params[:id]).update(workout_params.to_h)
      head :ok
    else
      flash[:alert] = 'Workout title cannot be blank'
    end
  end
  

  private

  def workout_params
    params.require(:workout).permit(:id, :title, :completed, :completed_filter)
  end


  def profile_params
    params.permit(:page)    
  end


end
