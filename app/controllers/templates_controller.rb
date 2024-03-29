class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  def index
    @exercises = Exercise.all        
    @templates = Template.all
  end

  # GET /templates/1
  def show
  end

  # GET /templates/new
  def new
    # unless template_params[:routine_id]
    #   redirect_to :controller => 'routines', :action => 'index'
    # end
    @exercises = Exercise.all    
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to @template, notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /templates/1
  def update
    if @template.update(template_params)
      redirect_to @template, notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /templates/1
  def destroy
    @template.destroy
    redirect_to templates_url, notice: 'Template was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def template_params
      params.fetch(:template, {}).permit(:id, :routine_id, :sets, :reps, :group, :progression_type)
    end
end