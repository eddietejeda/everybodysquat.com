# frozen_string_literal: true

module ChartsHelper
  
  def render_progress_chart
    content_tag(:div, class: "chart", data: {controller: 'chart'}) do
      content_tag(:canvas, "", class: "show", data: {target: 'chart.show'} )
    end
  end

end

