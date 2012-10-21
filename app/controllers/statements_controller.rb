class StatementsController < ApplicationController
  # GET /statements
  # GET /statements.json
  def index
    @topic = Topic.where(:name => params[:name]).first
    @statements = @topic.statements.joins("LEFT OUTER JOIN categories_statements cs ON statements.id = cs.statement_id").where("cs.statement_id IS NOT NULL")
  end
end
