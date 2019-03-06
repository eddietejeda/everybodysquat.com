require 'rails_helper'

RSpec.describe "exercise_routines/index", type: :view do
  before(:each) do
    assign(:exercise_routines, [
      ExerciseRoutine.create!(),
      ExerciseRoutine.create!()
    ])
  end

  it "renders a list of exercise_routines" do
    render
  end
end
