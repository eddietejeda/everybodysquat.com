# frozen_string_literal: true

class RoutinesController < ApplicationController

  def index
    @routines = Routine.all
  end

  def new
  end

  def edit
  end



end