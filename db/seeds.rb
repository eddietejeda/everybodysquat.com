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

BASELINE_COUNT = 10


exercise_list = [ "Bench", "Squat", "Deadlift", "Overhead Press", "Bent-Over Row", 
                  "Power Clean", "Clean", "Snatch", "Curl", "Tricep Dip"]
        
puts "Creating exercises sample data"
exercises = []
(BASELINE_COUNT).times do |i| 
  exercises << {
    name: exercise_list.shift || "exercise #{i}"
  } 
end 
Exercise.create(exercises)



puts "Creating routine sample data"
routines = []
(BASELINE_COUNT/2).times do |i| 
  routines << {
    name: "#{5+i}x#{5+i}",
    description: "M-W-F",
    # group: [1,2].sample,
    # exercise_target_reps: 5
    # pattern: ["Monday", "Wednesday", "Friday"]

  } 
end 
Routine.create(routines)


puts "Creating routines/exercises pairing sample data"
exercises_routines = []
(BASELINE_COUNT).times do |i| 
  exercises_routines << {
    routine_id: Routine.first(2).map{|r|r.id}.sample,
    exercise_id: Exercise.first(4).map{|e|e.id}.sample,
    group: "A",
    progression_type: "linear",
    increment_by: 5,
    sets: 5,
    reps: 5
  } 
end 
ExerciseRoutine.create(exercises_routines)


puts "Creating user sample data"
users = []
(BASELINE_COUNT/2).times do |i|
  users << {
    username: "eddie#{i}",
    name: "John #{i}",
    about: "Lorem ipsum #{i}",
    website: "www.hell#{i}.com",
    instagram: "instagram.com/john#{i}",
    twitter: "twitter.com/john#{i}",
    facebook: "facebook.com/john#{i}",
    photo: "photo.com/john#{i}",
    email: "email#{i}@localhost.com",
    routine_id: Routine.first.id,
    coach_id: 0,
    is_coach: false,
    is_admin: false,
    password: "hello-WORLD-1"
  } 
end 
User.create(users)

#create random user
c = User.last
c.routine_id  = Routine.first.id
c.is_admin    = false
c.is_coach    = false
c.coach_id    = User.first.id
c.password    = "hello-WORLD-1"
c.save!


#create admin/coach
u = User.first
u.routine_id = Routine.first.id
u.is_admin = true
u.is_coach = true
u.password = "hello-WORLD-1"
u.save!



puts "Creating workouts sample data"

User.all.each do |u|
  u.create_workout
  u.create_workout
end