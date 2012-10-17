class PropagateDatabase 
  $apiRequest = nil
  
  def self.initial_populate
    $apiRequest = ApiRequest.new
    $jsonObj = $apiRequest.getMasterIssueJson
    
    $issuesObject = $jsonObj['objects']
    
    $issuesObject.each do |issue|
      hash = {'name' => issue['name'], 'count' => issue['statement_count']}
      $topicObj = Topic.new(hash)
      
      $statementsJson = $apiRequest.getNextResults(issue['statement_url'], false)
          
      process_topic_statements($topicObj, $statementsJson)
      
      $topicObj.save
    end
  end
  
  def self.process_topic_statements(topic, statementsJson)
    $nextLink = statementsJson['meta']['next']
    $statements = statementsJson['objects']    
    
    $statements.each do |statement|
      process_a_statement(topic, statement)
    end
    
    if not $nextLink.nil?
      $nextStatementJson = $apiRequest.getNextResults($nextLink, true)
      process_topic_statements(topic, $nextStatementJson)
    end
  end
  
  def self.process_a_statement(topic, aStatement)
    $transcriptText = aStatement['text']
    
    hash = {'transcript' => $transcriptText, 
            'url' => aStatement['transcript_source_url'], 
            'date' => aStatement['date'],
            'speaker' => aStatement['speaker']['display_name']}
            
    $statementObj = topic.statements.build(hash)
    
    process_statement_categories($transcriptText, $statementObj)
    
    $statementObj.save    
  end
  
  def self.process_statement_categories(aTranscript, aStatement)
    $catArticleHash = $apiRequest.getCategoryArticleHashForStatement(aTranscript)
    
    $catArticleHash.each do |category, articles|
      $categoryObj = aStatement.categories.build(:name => category)
      
      process_category_articles($categoryObj, articles)
      
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