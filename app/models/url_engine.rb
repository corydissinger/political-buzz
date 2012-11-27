class UrlEngine
  # washington post constants
  WPOST_BASE_URL = 'http://api.washingtonpost.com/'
  TROVE = 'trove/v1/analysis'
  BY_STATEMENT = 'politics/transcripts/api/v1/statement/'
  PHRASES_BY_ENTITY = '/phrases/legislator.json?'
  WPOST_API_KEY = '&key='
  WPOST_API_KEY_ONLY = '/?key='
  WPOST_API_KEY_NO_SLASH = '?key='
  LIMIT = '&limit=30'
  ORDER_RECENT = '&order_by=-date'

  # npr constants
  NPR_KEY = '&apiKey='
  NPR_STEM = 'http://api.npr.org/query?'
  SEARCH_PARMS = '&startDate=2012-01-01&endDate=2012-12-31&sort=relevance&output=JSON&numResults=5&searchType=mainText'
  TERM = '&searchTerm='

  def getFirstStatementListUrl
    return WPOST_BASE_URL + BY_STATEMENT + WPOST_API_KEY_NO_SLASH + LIMIT 
  end

  def getNprArticlesUrl(entity)
    return NPR_STEM + SEARCH_PARMS + TERM + entity + NPR_KEY       
  end      

  def troveAnalysis
    return WPOST_BASE_URL + TROVE + WPOST_API_KEY_NO_SLASH
  end

  def getStatementUrlById(statementId)
    return WPOST_BASE_URL + BY_STATEMENT + statementId.to_s + WPOST_API_KEY_ONLY
  end    
  
  def getNextIssueUrl(remainderUrl)
    return WPOST_BASE_URL + remainderUrl + LIMIT        
  end
  
end