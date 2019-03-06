require 'rails_helper'

RSpec.describe "exercise_routines/edit", type: :view do
  before(:each) do
    @exercise_routine = assign(:exercise_routine, ExerciseRoutine.create!())
  end

  it "renders the edit exercise_routine form" do
    render

    assert_select "form[action=?][method=?]", exercise_routine_path(@exercise_routine), "post" do
    end
  end
end
