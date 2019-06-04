class Api::V1::AnnotationsController < ApplicationController
  before_action :authenticated

  # GET /annotations?book_id=:gutenberg_id
  # Serves all annotations with associated book_id
  # If no book_id, serves all annotations by user_id
  def index
    user = logged_in?
    if query_params["book_id"]
      book_id = query_params["book_id"].to_i

      render json: Annotation.allByBook(user, book_id)
    else
      render json: Annotation.allByUser(user)
    end
  end

  #GET annotations/:id
  def show
    render json: Annotation.find(params[:id]).serialize
  end

  #PATCH annotations/:id
  #TODO -- Edit Feature
  def update
    annotation = Annotation.find(update_params["id"])
    user = logged_in?
    if user.id === annotation.user_id
      if annotation.update(body: update_params["body"], title: update_params["title"])
        render json: {success: true, annotation: annotation}
      else
        render json: {success: false}
      end
    end
  end

  #POST annotations/likes
  #Creates new like
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

  #DELETE annotations/:id
  #restricted to annotation's user
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

  #POST annotations/
  def create
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

  def update_params
    params.require("annotation").permit("title", "body", "id")
  end

  def like_params
    params.require("annotation").permit("id")
  end
end
