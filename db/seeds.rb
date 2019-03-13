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
exercises_routines = []
exercise_pattern.each do |group_name, exercise_keys|

  exercise_keys.each do |exercise_key|
    exercise_name = exercise_list.fetch(exercise_key)

    exercises_routines << {
      routine_id: Routine.first.id,
      exercise_id: Exercise.where(name: exercise_name).first.id,
      exercise_group: "#{group_name}",
      progression_type: "linear", #
      # progression_type: "percent/fixed",
      incremention_scheme: [5, 5, 5, 5, 5],
      sets: 5,
      reps: 5,
#      weight_type: "kg" 
    } 
  end
end 
Template.create(exercises_routines)


puts "Creating user sample data"
user = {
    username: "root",
    name: "Super User",
    about: "",
    website: "",
    instagram: "",
    twitter: "",
    facebook: "",
    photo: "",
    email: "admin@everybodysquat.com",
    routine_id: Routine.first.id,
    coach_id: 0,
    is_coach: false,
    is_admin: true,
    approved: true,
    password: "this should change as soon as possible. you wil not want to type this again!"
} 
User.create(user)