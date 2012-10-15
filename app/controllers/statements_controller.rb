class StatementsController < ApplicationController
  # GET /statements
  # GET /statements.json
  def index
    @topic = Topic.where("name = ?", params[:name]).first
    @statements = @topic.statements.all
  end
end
