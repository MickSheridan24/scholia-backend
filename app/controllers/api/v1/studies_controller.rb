class Api::V1::StudiesController < ApplicationController
  def index
    #filter by user_id, categories, book
    render json: Study.all, except: [:created_at, :updated_at]
  end

  def show
    #with/without subscribers, contributors, annotations
    render json: Study.find(params[:id]), except: [:created_at, :updated_at]
  end

  def update
    #update description
    #add subscribers/contributors
    render json: {response: "STUDIES CONTROLLER UPDATE"}
  end

  def create
    @study = Study.create(study_params)
    render json: @study
  end

  def destroy
    render json: {response: "STUDIES CONTROLLER DESTROY"}
  end

  private

  def study_params
    params.require("study").permit("name", "description", "public_subscribe", "public_contribute")
  end
end
