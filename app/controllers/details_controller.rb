class DetailsController < ApplicationController
  def index
    grabber = ApiInterface::JsonProvider.new
    @statementdetails = grabber.getStatementById(params[:id])
    @categoryUrlHash = grabber.getEntityUrlHashForStatement(@statementdetails['text'])    
  end
end
