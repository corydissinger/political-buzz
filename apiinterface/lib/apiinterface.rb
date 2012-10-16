require 'json'
require 'net/http'

module ApiInterface
  class JsonProvider
    def getEntityUrlHashForStatement(statement)
      $troveResults = getTroveAnalysis(statement)
      
      $entities = $troveResults['entities']['resolved']
      
      $categoryUrlPairs = Hash.new
      
      $entities.each do |entity|
        $aTopic = entity['resource']['name']
        $nprList = getNprArticles($aTopic)
        
        $entityUrlArray = []
        $nprList.each_pair do |story, val|
          if val.is_a? String then
            next
          end
          if val.is_a? Array then
            next
          end
          if val.has_key?('story')
            val['story'].each do |links|
              $entityUrlArray << links['link'][0]['$text']
            end
          end
        end
        $categoryUrlPairs[$aTopic] = $entityUrlArray
      end
      
      return $categoryUrlPairs      
    end

    def getIssueResults(anIssue)
      $anUrl = getCompleteIssueUrl(anIssue)
      
      $jsonResult = getJson($anUrl)
      
      return $jsonResult  
    end

    def getNextResults(nextUrl, isKeyProvided)
      $anUrl = getCompleteNextUrl(nextUrl, isKeyProvided)
      
      $jsonResult = getJson($anUrl)
      
      return $jsonResult
    end
    
    def getNprArticles(entity)
      urlEngine = UrlEngine
      $nprUrl = urlEngine.getNprArticles(entity)
      
      $jsonResult = getJson($nprUrl)
      
      return $jsonResult
    end
    
    def getTroveAnalysis(text)
      urlEngine = UrlEngine
      
      $troveUrl = urlEngine.troveAnalysis()
      
      return getJsonByPost(text, $troveUrl)
    end
    
    
    def getStatementById(statementId)
      $anUrl = getCompleteStatementUrl(statementId)
      
      $jsonResult = getJson($anUrl)
      
      return $jsonResult
    end
    
    def getJson(targetUrl)
      url = URI.parse(URI.encode(targetUrl))
      resp = Net::HTTP.get_response(url) 
      data = resp.body
      result = {} 

      begin
        result = JSON.parse(data)    
      rescue Exception => e
        puts 'Encountered following exception' + e
        puts 'getJsonBy failed - The following input returned no parseable JSON'
        puts targetUrl
      end
  
      return result    
    end
      
    def getJsonByPost(text, url)
      uri = URI.parse(url)
      params = {'doc' => {'body' => text}.to_json}

      request = Net::HTTP::Post.new("#{uri.path}?#{uri.query}")
      request.set_form_data(params)
      
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.request(request)
      result = {}

      begin
        result = JSON.parse(response.body)
      rescue Exception => e
        puts 'Encountered following exception' + e
        puts 'getJsonByPost failed - The following input returned no parseable JSON'
        puts url
        puts text
      end

      return result
    end      
      
    def getCompleteNextUrl(nextUrl, isKeyProvided)
      urlEngine = UrlEngine
      
      $theUrl = urlEngine.getNextIssueUrl(nextUrl, isKeyProvided)
  
      return $theUrl      
    end
      
    def getCompleteIssueUrl(anIssue)
      urlEngine = UrlEngine
      
      $theUrl = urlEngine.getUrlForIssue(anIssue)
  
      return $theUrl
    end  
    
    def getCompleteStatementUrl(statementId)
      urlEngine = UrlEngine
      
      $theUrl = urlEngine.getStatementUrlById(statementId)
  
      return $theUrl      
    end
  end
  
  class UrlEngine
    # washington post constants
    WPOST_BASE_URL = 'http://api.washingtonpost.com/'
    BY_ISSUE = 'politics/transcripts/api/v1/issue/'
    TROVE = 'trove/v1/analysis'
    BY_STATEMENT = 'politics/transcripts/api/v1/statement/'
    ISS_NAME = '?name={"icontains":"'
    ISS_END = '"}'    
    PHRASES_BY_ENTITY = '/phrases/legislator.json?'
    WPOST_API_KEY = '&key=AD3597EC-2C77-4D91-B9FD-2071AD2FD9E3'
    WPOST_API_KEY_ONLY = '/?key=AD3597EC-2C77-4D91-B9FD-2071AD2FD9E3'
    WPOST_API_KEY_NO_SLASH = '?key=AD3597EC-2C77-4D91-B9FD-2071AD2FD9E3'
    LIMIT = '&limit=250'
    ORDER_RECENT = '&order_by=-date'

    # npr constants
    NPR_KEY = '&apiKey=MDEwMTA0MzEwMDEzNDc4MjkyNzBiZjJmNw001'
    NPR_STEM = 'http://api.npr.org/query?'
    SEARCH_PARMS = '&startDate=2012-01-01&endDate=2012-10-06&sort=relevance&output=JSON&numResults=5&searchType=mainText'
    TERM = '&searchTerm='

    def self.getNprArticles(entity)
      return NPR_STEM + SEARCH_PARMS + TERM + entity + NPR_KEY       
    end      

    def self.troveAnalysis()
      return WPOST_BASE_URL + TROVE + WPOST_API_KEY_NO_SLASH
    end

    def self.getUrlForIssue(issue)
      return WPOST_BASE_URL + BY_ISSUE + ISS_NAME + issue + ISS_END + WPOST_API_KEY
    end
    
    def self.getStatementUrlById(statementId)
      return WPOST_BASE_URL + BY_STATEMENT + statementId.to_s + WPOST_API_KEY_ONLY
    end    
    
    def self.getNextIssueUrl(remainderUrl, isKeyProvided)
      if isKeyProvided
        return WPOST_BASE_URL + remainderUrl + LIMIT + ORDER_RECENT       
      else
        return WPOST_BASE_URL + remainderUrl + WPOST_API_KEY + LIMIT + ORDER_RECENT 
      end
    end
  end  
end