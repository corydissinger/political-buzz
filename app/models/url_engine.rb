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
  SEARCH_PARMS = '&startDate=2012-01-01&endDate=2012-12-31&sort=relevance&output=JSON&numResults=5&searchType=mainText'
  TERM = '&searchTerm='

  def getMasterIssueListUrl
    return WPOST_BASE_URL + BY_ISSUE + WPOST_API_KEY_NO_SLASH 
  end

  def getNprArticlesUrl(entity)
    return NPR_STEM + SEARCH_PARMS + TERM + entity + NPR_KEY       
  end      

  def troveAnalysis
    return WPOST_BASE_URL + TROVE + WPOST_API_KEY_NO_SLASH
  end

  def getUrlForIssue(issue)
    return WPOST_BASE_URL + BY_ISSUE + ISS_NAME + issue + ISS_END + WPOST_API_KEY
  end
  
  def getStatementUrlById(statementId)
    return WPOST_BASE_URL + BY_STATEMENT + statementId.to_s + WPOST_API_KEY_ONLY
  end    
  
  def getNextIssueUrl(remainderUrl, isKeyProvided)
    if isKeyProvided
      return WPOST_BASE_URL + remainderUrl + LIMIT + ORDER_RECENT       
    else
      return WPOST_BASE_URL + remainderUrl + WPOST_API_KEY + LIMIT + ORDER_RECENT 
    end
  end
  
end