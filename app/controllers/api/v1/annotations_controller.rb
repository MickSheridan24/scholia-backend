class Api::V1::AnnotationsController < ApplicationController
  before_action :authenticated

  def index
    book_id = query_params["book_id"].to_i
    #Should respond to some filtering query (by user_id, by group_id, by category)
    render json: Annotation.allByBook(book_id)
  end

  def show
    #Serialize likes
    render json: Annotation.find(params[:id]), except: [:created_at, :updated_at], include: :categories
  end

  def update
    render json: {response: "ANNOTATIONS CONTROLLER UPDATE RESPONSE"}
  end

  def destroy
    user = logged_in?

    @annotation = Annotation.find(params[:id])
    if user.id == @annotation.user_id
      @annotation.destroy
      render json: {success: true, annotation: @annotation}
    else
      render json: {success: false}
    end
  end

  def create
    #VALIDATIONS
    user = logged_in?
    if user
      full_params = annotation_params
      full_params[:user_id] = user.id

      @annotation = Annotation.create(full_params)

      render json: {success: true, annotation: @annotation}
    else
      render json: {success: false}
    end
  end

  private

  def annotation_params
    params.require("annotation").permit("book_id", "study_id", "title", "color", "body", "location_p_index", "location_char_index", "public")
  end

  def query_params
    params.permit("book_id")
  end
end
