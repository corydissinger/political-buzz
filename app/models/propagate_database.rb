class PropagateDatabase 
  $apiRequest = nil
  
  def self.initial_populate
    $apiRequest = ApiRequest.new
    $jsonObj = $apiRequest.getFirstStatementJson
    
    iterate_through_api($jsonObj)
  end

  def self.update_db
    $apiRequest = ApiRequest.new
    $theCurrentUrl = Lasturl.all.first
    Rails.logger.info "Continued from URL: " + $theCurrentUrl.url
    $jsonObj = $apiRequest.getNextResults($theCurrentUrl.url)
      
    iterate_through_api($jsonObj)   
  end

  def self.iterate_through_api(jsonObj)
    $nextLink = nil
    $hasNextLink = true
    
    while $hasNextLink
      if $nextLink.nil?
        $nextLink = process_statements(jsonObj)
      else
        $nextJsonObj = $apiRequest.getNextResults($nextLink)
        $nextLink = process_statements($nextJsonObj)
        
        if $nextLink.nil?
          Rails.logger.info 'Next link is not available'
          return
        else
          Rails.logger.info 'Processing statements from: ' + $nextLink  
        end
        
        
        #TODO Is there a better way to maintain this?
        $lastUrl = Lasturl.all.first
        
        if not $lastUrl.nil?
          Lasturl.delete($lastUrl.id)
        end
          
        hash = {'url' => $nextLink}
        $lastUrl = Lasturl.new(hash)
        $lastUrl.save
      end
          
      if $nextLink.nil?
        $hasNextLink = false
      end
    end    
  end
  
  def self.process_statements(statementsJson)
    $nextLink = statementsJson['meta']['next']
    $statements = statementsJson['objects']    
    
    $statements.each do |statement|
      process_a_statement(statement)
    end

    return $nextLink    
  end
  
  def self.process_a_statement(aStatement)
    $transcriptText = aStatement['text']
    
    hash = {'transcript' => $transcriptText, 
            'url' => aStatement['transcript_source_url'], 
            'date' => aStatement['date'],
            'speaker' => aStatement['speaker']['display_name']}
            
    $statementObj = Statement.new(hash)
    
    process_statement_categories($transcriptText, $statementObj)
    
    if $statementObj.valid?
      $statementObj.save
    end    
  end
  
  def self.process_statement_categories(aTranscript, aStatement)
    $catArticleHash = $apiRequest.getCategoryArticleHashForStatement(aTranscript)
    
    $catArticleHash.each do |category, articles|
      $categoryObj = aStatement.categories.build(:name => category)
      
      process_category_articles($categoryObj, articles)

      $tempName = category.dup
      $categoryObj.name = $tempName.gsub!('%20',' ')
      
      if $categoryObj.valid?
        $categoryObj.save
        Rails.logger.info 'Added category' + $categoryObj.name
      end      
    end

  end  
  
  def self.process_category_articles(aCategory, articles)
    articles.each do |article|
      $articleObj = aCategory.articles.build(:url => article)
      
      if $articleObj.valid?
        $articleObj.save
        Rails.logger.info 'Added article ' + $articleObj.url
      end
    end
  end
  
end