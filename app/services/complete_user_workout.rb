class CompleteUserWorkout
  
  
  def initialize(user)
    @user = user
  end

  def call(workout)
    
    # workout = @user.active_workout
    workout.results = generate_results(workout)
    workout.completed_at = DateTime.now
    workout.active = false
    workout.save!
    workout
  
  end
  

  
  def generate_results(workout)
    
    workout.distinct_exercises.map do |exercise|
      setts = Sett.where(user_id: @user.id, workout_id: workout.id, exercise_id: exercise.id)
      # byebug
      {
        exercise_id:      exercise.id,
        name:             exercise.name,
        weight:           setts.max_by{|s|s.weight}.weight,
        reps:             setts.max_by{|s|s.weight}.reps_completed,
        sets:             setts.map{|s|s.reps_goal == s.reps_completed}.count(true),
        success:          exercise_setts_succcessful?(workout.id, exercise.id)
      }
    end
  end
  
  
  
  def exercise_setts_succcessful?(workout_id, exercise_id)
    successful_sets = Workout.find(workout_id).setts.where(exercise_id: exercise_id).map do |e|
      (e.reps_completed == e.reps_goal) && (e.reps_completed > 0)
    end
    Sett.where(workout_id: workout_id, exercise_id: exercise_id).exists? && successful_sets.all? {|a|a}
  end
  
  
end