class Api::V1::StudiesController < ApplicationController
  before_action :authenticated

  #GET /studies
  def index
    render json: Study.serialize_all(logged_in?)
  end

  #GET /studies/:id
  def show
    render json: Study.find(params[:id]), except: [:created_at, :updated_at]
  end

  #PATCH /studies/:id
  #TODO
  def update
    render json: {response: "STUDIES CONTROLLER UPDATE"}
  end

  #POST /subscriptions
  def subscribe
    user = logged_in?
    study = Study.find(params[:study_id].to_i)
    subscription = Subscriber.create(user_id: user.id, study_id: study.id)
    if (subscription)
      render json: {success: true, subscription: subscription}
    else
      render json: {success: false}
    end
  end

  #DELETE /subscriptions/:id
  def unsubscribe
    user = logged_in?
    study = Study.find(params["id"].to_i)
    subscriptions = Subscriber.where(user_id: user.id, study_id: study.id)

    if (subscriptions.destroy_all)
      render json: {success: true, subscription: subscriptions.first}
    else
      render json: {success: false}
    end
  end

  #POST /studies
  #TODO
  def create
    @study = Study.create(study_params)
    render json: @study
  end

  #DELETE /studies/:id
  #TODO
  def destroy
    render json: {response: "STUDIES CONTROLLER DESTROY"}
  end

  private

  def study_params
    params.require("study").permit("name", "description", "public_subscribe", "public_contribute")
  end
end
