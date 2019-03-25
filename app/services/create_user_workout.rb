class CreateUserWorkout
  
  
  def initialize(user)
    @user = user
  end
  
  
  def call
    exercise_group_name = @user.next_exercise_group_name
    exercises_list_grouped = @user.template_exercises_by_group(exercise_group_name)
    
    workout = Workout.create({
      user_id: current_user.id,
      routine_id: current_user.routine_id,
      active: true,
      exercise_group: exercise_group_name,
      training_maxes: adjust_training_maxes_by_group(exercise_group_name)
    })


    # We copy the template to a Sett
    setts = []
    exercises_list_grouped.each do |template|
      template.sets.times do |set_number|
        setts << {
          workout_id: workout.id,
          exercise_id: template.exercise_id,
          weight: @user.weight_for_next_set(template.exercise_id, template.exercise_group, set_number),
          set_goal: template.sets,
          reps_goal: template.reps.fetch(set_number),
          reps_completed: 0,
          user_id: @user.id
        }
      end
    end
    Sett.create(setts)
    
    workout    
  end
  
end