# frozen_string_literal: true

class WorkoutsController < ApplicationController
  # helper_method :filtering_params

  def index
    @workouts = Workout.all.order(id: :desc).limit(5)
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

  def update
    p workout_params[:title]
    if Workout.find(params[:id]).update(workout_params.to_h)
      head :ok
    else
      flash[:alert] = 'Workout title cannot be blank'
      # load_and_render_index
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
      w.active = false
      w.save!
    end
    redirect_to '/workouts'
  end



  private

  def workout_params
    params.require(:workout).permit(:id, :title, :completed, :completed_filter)
  end


end
