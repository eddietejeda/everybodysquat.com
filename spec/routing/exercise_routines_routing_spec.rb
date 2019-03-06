require "rails_helper"

RSpec.describe ExerciseRoutinesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/exercise_routines").to route_to("exercise_routines#index")
    end

    it "routes to #new" do
      expect(:get => "/exercise_routines/new").to route_to("exercise_routines#new")
    end

    it "routes to #show" do
      expect(:get => "/exercise_routines/1").to route_to("exercise_routines#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/exercise_routines/1/edit").to route_to("exercise_routines#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/exercise_routines").to route_to("exercise_routines#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/exercise_routines/1").to route_to("exercise_routines#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/exercise_routines/1").to route_to("exercise_routines#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/exercise_routines/1").to route_to("exercise_routines#destroy", :id => "1")
    end
  end
end
