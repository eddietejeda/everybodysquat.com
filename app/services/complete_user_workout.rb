class CompleteUserWorkout
  
  
  def initialize(user)
    @user = user
  end

  def call
    if @user.has_active_workout?
      workout = @user.active_workout
      workout.results = generate_results(workout)
      workout.training_maxes = training_max_results(workout)
      workout.completed_at = DateTime.now
      workout.active = false
      workout.save!
      workout
    end
  end
  
  
  def generate_results(workout)
    workout.distinct_exercises.map do |exercise|
      {"#{exercise.id}".to_i => Sett.where(workout_id: workout.id, exercise_id: exercise.id).maximum('weight')}.as_json
    end
  end
  
  def training_max_results(workout)
    
    workout.distinct_exercises.map do |exercise|

      setts = Sett.where(user_id: @user.id, workout_id: workout.id, exercise_id: exercise.id)

      {
        exercise_id:      exercise.id,
        weight:           setts.maximum('weight'),
        reps:             setts.maximum('reps_completed'),
        sets:             setts.count,
        success:          exercise_setts_succcessful?(workout.id, exercise.id)
      }

      # {"#{exercise.id}".to_i => Sett.where(workout_id: workout.id, exercise_id: exercise.id).maximum('weight')}.as_json

    end
    

  end
  
  
  
  def exercise_setts_succcessful?(workout_id, exercise_id)
    successful_sets = Workout.find(workout_id).setts.where(exercise_id: exercise_id).map{|e|
      (e.reps_completed == e.reps_goal) && (e.reps_completed > 0)
    }
    Sett.where(workout_id: workout_id, exercise_id: exercise_id).exists? && successful_sets.all? {|a|a}
  end
  
  
end