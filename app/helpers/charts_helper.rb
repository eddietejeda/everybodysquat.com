# frozen_string_literal: true

module ChartsHelper
  
  def render_progress_chart
    
    if current_user.workouts.count > 4
      content_tag(:div, class: "chart", data: {controller: 'chart'}) do
        content_tag(:canvas, "", class: "show", data: {target: 'chart.show'} )
      end
    else
      content_tag(:div, content_tag(:p, "Charts will appear after you complete four workouts"), class: "strong")      
    end
  end

end

