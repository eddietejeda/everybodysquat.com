class ExerciseRoutinesController < ApplicationController
  before_action :set_exercise_routine, only: [:show, :edit, :update, :destroy]

  # GET /exercise_routines
  def index
    @exercise_routines = ExerciseRoutine.all
  end

  # GET /exercise_routines/1
  def show
  end

  # GET /exercise_routines/new
  def new
    @exercise_routine = ExerciseRoutine.new
  end

  # GET /exercise_routines/1/edit
  def edit
  end

  # POST /exercise_routines
  def create
    @exercise_routine = ExerciseRoutine.new(exercise_routine_params)

    if @exercise_routine.save
      redirect_to "/routines/#{@exercise_routine.routine_id}/edit", notice: 'Exercise routine was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /exercise_routines/1
  def update
    if @exercise_routine.update(exercise_routine_params)
      redirect_to @exercise_routine, notice: 'Exercise routine was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /exercise_routines/1
  def destroy
    @exercise_routine.destroy
    redirect_to exercise_routines_url, notice: 'Exercise routine was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_routine
      @exercise_routine = ExerciseRoutine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def exercise_routine_params
      params.fetch(:exercise_routine, {}).permit(:exercise_id, :sets, :reps, :group, :increment_by, :progression_type, :routine_id)
    end
end
