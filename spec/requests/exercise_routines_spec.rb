require 'rails_helper'

RSpec.describe "ExerciseRoutines", type: :request do
  describe "GET /exercise_routines" do
    it "works! (now write some real specs)" do
      get exercise_routines_path
      expect(response).to have_http_status(200)
    end
  end
end
