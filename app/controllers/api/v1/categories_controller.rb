class Api::V1::CategoriesController < ApplicationController
  def index
    render json: Category.all, except: [:created_at, :updated_at]
  end

  def show
    render json: Category.find(params[:id]), except: [:created_at, :updated_at]
  end
end
