class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.json
  def index
    @topics = Category.order("name DESC").all
  end

end
