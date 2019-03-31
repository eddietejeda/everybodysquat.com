
class CreateUserWorkout
  
  
  def initialize(user)
    @user = user
  end
  
  
  def call
    exercise_group_name = next_exercise_group_name
    template_exercises_list = template_exercises_by_group(exercise_group_name)
    
    new_workout = Workout.create({
      user_id:          @user.id,
      routine_id:       @user.routine_id,
      active:           true,
      exercise_group:   exercise_group_name,
      results:          adjust_workout_results(template_exercises_list)
    })


    # We copy the template to a Sett
    setts = []
    template_exercises_list.each do |template|
      template.sets.times do |set_number|
        setts << {
          workout_id:       new_workout.id,
          exercise_id:      template.exercise_id,
          weight:           adjust_weight_for_set(new_workout, template.exercise_id, set_number),
          set_goal:         template.sets,
          reps_goal:        template.reps.fetch(set_number),
          reps_completed:   0,
          user_id:          @user.id
        }
      end
    end
    Sett.create(setts)
    
    new_workout    
  end
  
  
  private
  
  
    

    
    def template_exercises_by_group(exercise_group)
      Template.where("routine_id = :routine_id AND exercise_group = :exercise_group", { 
        routine_id: @user.routine.id, exercise_group: exercise_group 
      }).order(:exercise_id)
    end



    def adjust_weight_for_set(workout, exercise_id, set_number)
      # TODO: At the moment, each set has the same training max.
      # But is the method that would add logic to determine how how increase each set by
      workout.results.find{|goal| goal["exercise_id"] == exercise_id}.to_h["weight"]
    end
    



    def next_exercise_group_name
      # get all possible exercise groups    
      all_exercise_groups = @user.routine.exercise_groups 
    
      #we use try() just in case there is no previous workout
      previous_workout_group = most_recent_workout.try(:exercise_group)

      # default to zero, but lets look inside. 
      current_group_pos = 0
      if !previous_workout_group.blank?
        # find the previous workout in the list
        previous_workout_pos = all_exercise_groups.index(previous_workout_group)
        # find the previous workout in the list, if it's the last item on the list, start back at 0
        current_group_pos = (previous_workout_pos == all_exercise_groups.length - 1) ? 0 : previous_workout_pos + 1
      end  
    
      all_exercise_groups.fetch(current_group_pos)
    end
  

    # def adjust_workout_maxes_by_group(exercise_group)
    #   template_exercises_by_group(exercise_group).map{|e|
    #     {
    #       exercise_id: e.exercise_id,
    #       weight: weight_for_training_max(e.exercise_id)
    #     }
    #   }
    # end

    def most_recent_workout_by_group(group_name)
      Workout.where(user_id: self.id, exercise_group: group_name).order(:id).last
    end


    def most_recent_workout
      Workout.where(user_id: @user.id).order(:created_at).last
    end


    # previous_workout_before the workout before the a specific date
    # TODO: is this performant? 
    def previous_workout_before(before_date)
      Workout.where("user_id = :user_id AND created_at < :created_at", { 
        user_id: self.id, created_at: before_date 
      }).first
    end

    def previous_workout_exercise_setts(exercise_id)
      @user.previous_workout ? Sett.where(workout_id: @user.previous_workout.id, exercise_id: exercise_id).order(created_at: :desc) : Sett.none
    end

    # def weight_of_previous_workout_exercise(exercise_id)
    #   previous_workout.results{|e|
    #     e["exercise_id"] == exercise_id
    #   }.to_h["weight"] || 45
    # end
    
  


    def adjust_workout_results(template_exercises_list)
      template_exercises_list.map{|template_exercise|
        {
          exercise_id:      template_exercise.exercise_id, 
          weight:           weight_for_training_max(template_exercise.exercise_id),
          success:          false
        }
      }
    end
    

    def weight_for_training_max(exercise_id)
      
      if should_increase_weight?(exercise_id)
        # increase
        previous_successful_training_max(exercise_id).add(5)

      elsif should_decrease_weight?(exercise_id)
        # decrease
        amount = previous_successful_training_max(exercise_id).subtract(5)
        amount < @user.bar_weight ? @user.bar_weight : amount
      else
        # stay the same
        (previous_successful_training_max(exercise_id) > 0) ? previous_successful_training_max(exercise_id) : @user.bar_weight
      end
    end
  
  
  
    def should_increase_weight?(exercise_id)
      # :results => [
      # [0] {
      #        "weight" => 0,
      #       "success" => false,
      #   "exercise_id" => 4
      # },
      # [1] {
      #        "weight" => 0,
      #       "success" => false,
      #   "exercise_id" => 5
      # },
      # [2] {
      #        "weight" => 0,
      #       "success" => false,
      #   "exercise_id" => 6
      
      # TODO: This code: '{"exercise_id": '+exercise_id.to_s+', "success": true}' was easier than
      # doing a bunch of string escaping. Maybe there is a better way?
      query_params = {
        results: '[{"exercise_id": '+exercise_id.to_s+'}]',
        created_at: DateTime.now - 7.days
      }

      Workout.where("results @> :results AND created_at > :created_at", query_params).order(id: :desc).limit(1).any?
    end
  
  
    #TODO:
    def should_decrease_weight?(exercise_id)

      query_params = {
        results: '[{"exercise_id": '+exercise_id.to_s+', "success": false}]',
        created_at: DateTime.now - 7.days
      }
            
      Workout.where("results @> :results AND created_at > :created_at", query_params).order(id: :desc).limit(3).count > 2
    end
  
    def previous_successful_training_max(exercise_id)
      query_params = { results: '[{"exercise_id": '+exercise_id.to_s+', "success": true}]' }

      amount = Workout.where("results @> :results", query_params).order(id: :desc).limit(1).last.try(:results).to_a.find{|e| e.to_h["exercise_id"] == exercise_id }.to_h["weight"].to_i    
      amount < @user.bar_weight ? @user.bar_weight : amount
    end

  
  

  
end