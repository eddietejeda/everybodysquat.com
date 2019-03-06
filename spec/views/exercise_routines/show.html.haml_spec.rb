require 'rails_helper'

RSpec.describe "exercise_routines/show", type: :view do
  before(:each) do
    @exercise_routine = assign(:exercise_routine, ExerciseRoutine.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
