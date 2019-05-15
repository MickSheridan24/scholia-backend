class Api::V1::AnnotationsController < ApplicationController
  before_action :authenticated, only: [:destroy]

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
    #AUTH -- update text
    #NO AUTH -- add like
    render json: {response: "ANNOTATIONS CONTROLLER UPDATE RESPONSE"}
  end

  def destroy
    #AUTH
    render json: {response: "ANNOTATIONS CONTROLLER DELETE RESPONSE"}
  end

  def create
    #VALIDATIONS
    @annotation = Annotation.create(annotation_params)
    render json: @annotation
  end

  private

  def annotation_params
    params.require("annotation").permit("book_id", "user_id", "study_id", "title", "color", "body", "location_p_index", "location_char_index", "color", "public")
  end

  def query_params
    params.permit("book_id")
  end
end
