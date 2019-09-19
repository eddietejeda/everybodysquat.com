# frozen_string_literal: true

class SubscriptionsController < ApplicationController

  # GET /subscriptions
  def index
    redirect_to root_path
  end

  # GET /subscriptions/1
  def show
  end

  # GET /subscriptions/new
  def new
    @subscription = Routine.new
  end

  # GET /subscriptions/1/edit
  def edit
  end

  # POST /subscriptions
  def create
    @subscription = Routine.new(subscription_params)

    if @subscription.save
      redirect_to @subscription, notice: 'Routine was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /subscriptions/1
  def update
    if @subscription.update(subscription_params)
      redirect_to @subscription, notice: 'Routine was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /subscriptions/1
  def destroy
    @subscription.destroy
    redirect_to subscriptions_url, notice: 'Routine was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Routine.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subscription_params
      params.fetch(:subscription, {}).permit(:name, :description)
    
    end
end
