# frozen_string_literal: true

class WorkoutsController < ApplicationController
  # helper_method :filtering_params

  def index
    paginate = 100
    
    offset = profile_params[:page].to_i * paginate
    
    @workouts = current_user.workouts.order(began_at: :desc).offset(offset).limit(paginate)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @workouts.as_json  }
    end
  end

  def show
    @workout = Workout.where(id: params[:id], user_id: current_user.id).first
  end

  def edit
    @workout = Workout.where(id: params[:id], user_id: current_user.id).first
  end

  def start
    if current_user.routine_id > 0
    
      @workout = current_user.active_workout || current_user.start_workout
      fresh_when(@workout)
      unless @workout
        flash[:alert] = 'Cannot create a new task'
      end
      redirect_to edit_workout_path(@workout)
      
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
    current_user.end_workout(workout)
    cookies.delete :restTime
    redirect_to workouts_path 
  end

  
  def update
    Rails.logger.info{ workout_params[:title] }
    if Workout.find(params[:id]).update(workout_params.to_h)
      head :ok
    else
      flash[:alert] = 'Workout title cannot be blank'
    end
  end
  


  def destroy
    @workout = Workout.where(id: params[:id], user_id: current_user.id).first
    
    if @workout.destroy
      head :ok
    else
      flash[:alert] = 'Cannot delete workout'
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
