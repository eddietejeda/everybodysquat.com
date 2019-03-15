module UsersHelper
  
  
  def greet_user(current_time = Time.now)
    midnight = current_time.beginning_of_day.to_i
    noon = current_time.middle_of_day.to_i
    five_pm = current_time.change(hour: 17).to_i
    eight_pm = current_time.change(hour: 20).to_i
    current_time = current_time.to_i

    case 
     when midnight.upto(noon).include?(current_time)
       "Good Morning"
     when noon.upto(five_pm).include?(current_time)
       "Good Afternoon"
     when five_pm.upto(midnight).include?(current_time)
       "Good Evening"
     else
       "Good Evening"
    end
    # "Good Morning"
  end  
  
  
  def formated_date(current_time)
    current_time.strftime("%A, %b %d %Y")
  end
  
end
