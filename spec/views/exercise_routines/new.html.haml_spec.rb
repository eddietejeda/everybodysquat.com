require 'rails_helper'

RSpec.describe "exercise_routines/new", type: :view do
  before(:each) do
    assign(:exercise_routine, ExerciseRoutine.new())
  end

  it "renders new exercise_routine form" do
    render

    assert_select "form[action=?][method=?]", exercise_routines_path, "post" do
    end
  end
end
