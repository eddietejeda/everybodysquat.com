module User::Workouts
  extend ActiveSupport::Concern


  def start_workout
    CreateUserWorkout.new(self).call
  end
    
  
  def end_workout(workout)
    CompleteUserWorkout.new(self).call(workout)
  end
  
  
  def active_workout
    self.workouts.where("active = true").first
  end
  
  
  def has_active_workout?
    active_workout ? true : false
  end

  # previous_workout is looking for the previous before the current one.
  def previous_workout
    Workout.where(user_id: self.id).last(2).first
  end
  
  # most recent workout and previous might seem similar but it's important not to confuse them
  # most_recent_work gets the most recent workout, whether there is an active one or not
  def most_recent_workout
    Workout.where(user_id: self.id).last
  end


  def chart_user_workouts
    CreateUserWorkoutChart.new(self).call
  end
  
  
  # TODO: stale?
  def workout_exercise_was_succcessful(workout_id, exercise_id)
    successful_sets = Workout.find(workout_id).setts.where(exercise_id: exercise_id).map{|e|
      (e.reps_completed == e.reps_goal) && (e.reps_completed > 0)
    }
    self.where(exercise_id: exercise_id).exists? && successful_sets.all? {|a|a}
  end
  
  
  def next_workout_date
    # this is not pretty, but I needed to get this out quickly to test other things
    # TODO: rewrite to take multiple algorithms for different programs. this is currently 5x5
    # Routine.find(self.routine_id).templates.where(exercise_id: exercise_id, exercise_group: exercise_group).first.incremention_scheme.fetch(set_number).to_i
    week_array = [false,true,false,true,false,true,false] # this is basically 5x5/M-W-F
    wday = Time.now.wday

    week_array.each_with_index do |value, key|
      wnext = (wday + key)%week_array.count
      if week_array.fetch(wnext)
        return Time.now + key.days
      end
    end
    
    # We should never be here.
    Rails.logger.error {"User.next_workout_date not finding the next workout date and defaulting to tomorrow"}
    Time.now + 1.days
  end


  def personal_records
    
    response = []
    if self.routine
      response = self.routine.distinct_exercises.map {|exercise|
        self.highest_weight_sett(exercise.id).try("id")
      }
    end
    
    response.any? ? Sett.find(response) : []
    
  end


  def personal_achivements
    []
  end



  def highest_weight_sett(exercise_id)
    Sett.where(user_id: self.id, exercise_id: exercise_id).where("reps_completed > 0").order(weight: :desc).limit(1).first || Sett.none
  end

end




