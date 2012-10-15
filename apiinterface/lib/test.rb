require './apiinterface'

grabber = ApiInterface::JsonProvider.new
$jsonObj = grabber.getNextResults('/politics/transcripts/api/v1/statement/?format=json&issues__name=Economy', false)
puts $jsonObj['meta']
puts $jsonObj['objects']
