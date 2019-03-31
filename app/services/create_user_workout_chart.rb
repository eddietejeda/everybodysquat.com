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
      '#ffe0a3',
      '#ffa1ac',
      '#fabc60'
    ]


    # query_params = {
    #   training_maxes: '[{"exercise_id": 1, "success": true}]',
    # }
    #
    # Workout.where("training_maxes @> [{"exercise_id": 1, "success": true}]", query_params).order(id: :desc).limit(3).count > 2
    #



    datasets = @user.routine.exercises.distinct.map do |e|
      
      query = " SELECT   created_at AS x, max_weight->>'weight' AS y
                FROM     workouts, jsonb_array_elements(results) AS max_weight
                WHERE    results @> '[{\"exercise_id\": #{e.id}, \"success\": true}]'  AND 
                      	 max_weight->>'exercise_id' = '#{e.id}' AND
                         user_id = #{@user.id}
                ORDER BY created_at ASC"
        {
        label: e.name,
        data: Workout.find_by_sql(query).map{|f|
            { "x" => f["x"].strftime('%F %T'), "y" => f["y"] } if f["y"]
        }.compact,
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
        scales: {
          xAxes: [{
              type: "time",
              time: {
                format: "YYYY-MM-DD",
                tooltipFormat: 'lll',
                unit: 'day'
              },
              scaleLabel: {
                display: true,
                labelString: 'Date'
              },
              gridLines: {
                display: true ,
                color: "#FFFFFF"
              },
              ticks: {
                  beginAtZero: true
              }              
              
          }],
          yAxes: [{
            ticks: {
              beginAtZero: true,
              fixedStepSize: 1,
              precision:0
              
            },            
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