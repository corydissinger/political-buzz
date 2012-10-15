class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.order("count DESC").all
  end

end
