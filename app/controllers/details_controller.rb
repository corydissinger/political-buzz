class DetailsController < ApplicationController
  def index
    @statement = Statement.where(:id => params[:id]).first
    @categories = @statement.categories
  end
end
