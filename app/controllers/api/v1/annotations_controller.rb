class Api::V1::AnnotationsController < ApplicationController
  before_action :authenticated

  def index
    user = logged_in?
    if query_params["book_id"]
      book_id = query_params["book_id"].to_i

      render json: Annotation.allByBook(user, book_id)
    else
      render json: Annotation.allByUser(user)
    end
  end

  def show
    #Serialize likes
    render json: Annotation.find(params[:id]).serialize
  end

  def update
    render json: {response: "ANNOTATIONS CONTROLLER UPDATE RESPONSE"}
  end

  def like
    user = logged_in?
    annotation = Annotation.find(like_params["id"])

    if annotation.user_id != user.id
      if (Like.all.find { |l| l.user_id == user.id && l.annotation_id == annotation.id })
        render json: {success: false, message: "User cannot like a post twice"}
      else
        annotation.likes << Like.new(annotation_id: like_params["id"], user_id: user.id)
        render json: {success: true, like: annotation.likes.last}
      end
    else
      render json: {success: false, message: "User cannot like their own post"}
    end
  end

  def destroy
    user = logged_in?

    @annotation = Annotation.find(params[:id])
    if user.id == @annotation.user_id
      @annotation.destroy
      render json: {success: true, annotation: @annotation}
    else
      render json: {success: false, message: "User cannot delete other users' posts"}
    end
  end

  def create
    #VALIDATIONS
    user = logged_in?
    if user
      full_params = annotation_params
      full_params[:user_id] = user.id

      @annotation = Annotation.create(full_params)

      render json: {success: true, annotation: Annotation.serialize(user, @annotation, {})}
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

  def like_params
    params.require("annotation").permit("id")
  end
end
