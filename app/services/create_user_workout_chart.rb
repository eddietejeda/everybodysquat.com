class CreateUserWorkoutChart
  def initialize(user)
    @user = user
  end
  
  def call
    color_list = [
      '#11144c',
      '#3a9679',
      '#e16262',
      '#e3c4a8',
      '#4592af',
      '#226089',
      '#b7fbff',
      # '#fff6be',
      '#ffe0a3',
      '#ffa1ac',
      '#fabc60'

    ]

    datasets = @user.routine.exercises.distinct.map do |e|
      {
        label: e.name,
        data: Workout.select("created_at AS x, results->>'#{e.id}' AS y").where("user_id = :user_id", {user_id: 1}).order(:created_at).map{|f|
          { "x" => f["x"].strftime('%F %T'), "y" => f["y"] } 
        },
        fill: false,
        backgroundColor: color_list.pop,
        borderColor: color_list.pop
        
      }
    end
    
    
    response = {
      type: 'line',
      data: {
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,        
        # title: {
        #   display: true,
        #   text: "Progress"
        # },
        scales: {
          xAxes: [{
              type: "time",
              time: {
                format: "YYYY-MM-DD",
                tooltipFormat: 'lll'
              },
              scaleLabel: {
                display: true,
                labelString: 'Date'
              },
              gridLines: {
                display: true ,
                color: "#FFFFFF"
              }              
              
          }],
          yAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Weight'
            },
            gridLines: {
              display: true ,
              color: "#FFFFFF"
            },
          }]
        }
      } 
    }
    
    response
  end
end