require 'json'
require 'httparty'
require 'net/http'

class ApiRequest
  $urlEngine = nil
  
  def initialize
    $urlEngine = UrlEngine.new
  end
  
  def getCategoryArticleHashForStatement(statement)
    $troveResults = getTroveAnalysis(statement)
    
    $entities = $troveResults['entities']['resolved']
    
    $categoryUrlPairs = Hash.new
    
    #TODO - Is it possible to parse NPR JSON less confusingly? 
    #       Don't bash me for this until you try interpreting it! 
    $entities.each do |entity|
      $aTopic = entity['resource']['name']
      $nprList = getNprArticles($aTopic)
      
      $entityUrlArray = []
      $nprList.each_pair do |story, val|
        if isNprValueValid(val)
          val['story'].each do |links|
            $entityUrlArray << links['link'][0]['$text']
          end
        end
      end
      $categoryUrlPairs[$aTopic] = $entityUrlArray
    end
    
    return $categoryUrlPairs      
  end

  def isNprValueValid(aVal)
    if aVal.is_a? String or aVal.is_a? Array then
      return false
    elsif aVal.has_key?('story')
      return true
    else
      return false
    end
  end

  def getMasterIssueJson
    $anUrl = $urlEngine.getMasterIssueListUrl
    
    $jsonResult = getJson($anUrl)
    
    return $jsonResult
  end

  def getIssueResults(anIssue)
    $anUrl = $urlEngine.getUrlForIssue(anIssue)
    
    $jsonResult = getJson($anUrl)
    
    return $jsonResult  
  end

  def getNextResults(nextUrl, isKeyProvided)
    $anUrl = $urlEngine.getNextIssueUrl(nextUrl, isKeyProvided)
    
    $jsonResult = getJson($anUrl)
    
    return $jsonResult
  end
  
  def getNprArticles(entity)
    entity.gsub!(/\s+/,'%20')
    $nprUrl = $urlEngine.getNprArticlesUrl(entity)
    
    $jsonResult = getJson($nprUrl)
    
    return $jsonResult
  end
  
  def getTroveAnalysis(text)
    $troveUrl = $urlEngine.troveAnalysis()
    
    return getJsonByPost(text, $troveUrl)
  end
  
  
  def getStatementById(statementId)
    $anUrl = $urlEngine.getStatementUrlById(statementId)
    
    $jsonResult = getJson($anUrl)
    
    return $jsonResult
  end
  
  def getJson(targetUrl)
    response = HTTParty.get(targetUrl)
     
    result = {} 

    begin
      result = JSON.parse(response.body)    
    rescue Exception => e
      Rails.logger.info '-------BEGIN EXCEPTION--------'      
      Rails.logger.info 'Encountered following exception' + e
      Rails.logger.info 'getJsonBy failed - The following input returned no parseable JSON'
      Rails.logger.info targetUrl
      Rails.logger.info '-------END EXCEPTION--------'
    end
    
    return result    
  end
    
  def getJsonByPost(text, targetUrl)
    #TODO - Clean this up and post without timing out, EVER!
    params = {'doc' => {'body' => text}.to_json}
    
    response = HTTParty.post(targetUrl,
                       :body => params)
    result = {}

    begin
      result = JSON.parse(response.body)
    rescue Exception => e
      Rails.logger.info '-------BEGIN EXCEPTION--------'
      Rails.logger.info 'Encountered following exception' + e
      Rails.logger.info 'getJsonByPost failed - The following input returned no parseable JSON'
      Rails.logger.info uri
      Rails.logger.info text
      Rails.logger.info '-------END EXCEPTION--------'
    end

    return result
  end      

  class Trove
    include HTTParty
    format :json
    
    def self.text_analysis(fullurl, text)
      
    end
  end
end