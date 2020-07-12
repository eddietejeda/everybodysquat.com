# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Deleting sample table data"
User.delete_all
Routine.delete_all
Exercise.delete_all
Workout.delete_all
Sett.delete_all



puts "Creating exercises sample data"

exercise_list = [ "Squat", "Bench", "Bent-Over Row", "Overhead Press", "Deadlift", ]
exercises_query = []
exercise_list.each do |exercise| 
  exercises_query << {
    name: exercise
  } 
end 
Exercise.create(exercises_query)



puts "Creating routine sample data"
routines_query = {
  name: "5 x 5",
  description: "5x5 is a linear progression program for novice lifters",
  exercise_groups: ["Workout A", "Workout B"]
}
 
Routine.create(routines_query)


puts "Creating routines/exercises pairing sample data"
exercise_pattern ={
  "Workout A": [0, 1, 2],
  "Workout B": [0, 3, 4]  
}
templates = []
exercise_pattern.each do |group_name, exercise_keys|

  exercise_keys.each do |exercise_key|
    exercise_name = exercise_list.fetch(exercise_key)

    templates << {
      routine_id:           Routine.first.id,
      exercise_id:          Exercise.where(name: exercise_name).first.id,
      exercise_group:       group_name,
      workout_progression:  "linear",
      set_progression:      "fixed",
      incremention_scheme:  [5, 5, 5, 5, 5],
      reps:                 [5, 5, 5, 5, 5],
      sets:                 5,
      weight_type:          "kg"
    }
  end
end 
Template.create(templates)


puts "Creating user sample data"
user = {
    username: "admin",
    name: "Super User",
    about: "",
    email: "admin@localhost",
    routine_id: Routine.first.id,
    coach_id: 0,
    coach: false,
    admin: true,
    approved: true,
    password: "this should change as soon as possible. you will not want to type this again!"
} 
u = User.create(user)
u.save!


(1..50).each do |a|
  u.start_workout
  workout = u.active_workout
  u.end_workout(workout)  
end

Workout.space_workout_dates
