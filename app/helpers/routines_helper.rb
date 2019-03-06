module RoutinesHelper
  
  def associate_user_to_routine_path(routine)
    "/users/#{current_user.id}/routines/#{routine.id}"
  end
  
end
