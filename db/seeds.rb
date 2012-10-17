$grabber = nil
$currentIssue = nil
$currentTopicObj = nil
$currentStatementObj = nil
$currentCategoryObj = nil
$currentArticleObj = nil

$issuesUrl = {
# 'Energy' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Energy',
# 'Environment' =>'/politics/transcripts/api/v1/statement/?format=json&issues__name=Environment',
# 'Military Spending' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Military Spending',
# 'Jobs' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Jobs',
# 'Education' =>'/politics/transcripts/api/v1/statement/?format=json&issues__name=Education',
# 'Taxes' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Taxes',
# 'Economy' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Economy',
# 'Health Care' =>'/politics/transcripts/api/v1/statement/?format=json&issues__name=Health Care',
# 'Government Spending' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Government Spending',
# 'Iran' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Iran',
# 'Social Security' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Social Security',
# 'Foreign Policy' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Foreign Policy',
# 'Medicare' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Medicare',
# 'Immigration' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Immigration',
# 'Afghanistan' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Afghanistan',
'Gun Control' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Gun Control'
# 'Same-sex marriage' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Same-sex marriage',
# 'Abortion' => '/politics/transcripts/api/v1/statement/?format=json&issues__name=Abortion'
}

def processIssues(aStatementObject)
  
  hash = {'name' => $currentIssue, 'count' => aStatementObject['meta']['total_count']}
  $currentTopicObj = Topic.new(hash)
  
  $nextLink = aStatementObject['meta']['next']
  $statements = aStatementObject['objects']

  $statements.each do |statement|
    processAStatement(statement)
  end
  
  if $currentTopicObj.valid?
    $currentTopicObj.save
    Rails.logger.info 'Added topic' + $currentTopicObj.name
  end
  
  if not $nextLink.nil?
    $issueResults = $grabber.getNextResults($nextLink, true)
    processIssues($issueResults)
  end  
end

def processAStatement(aStatement)
  $transcriptText = aStatement['text']
  hash = {'transcript' => $transcriptText, 
          'url' => aStatement['transcript_source_url'], 
          'date' => aStatement['date'],
          'speaker' => aStatement['speaker']['display_name']}
          
  $currentStatementObj = $currentTopicObj.statements.build(hash)
  
  processStatementCategories($transcriptText)
  
  $currentStatementObj.save
end

def processStatementCategories(transcript)
  $catArticleHash = $grabber.getCategoryArticleHashForStatement(transcript)
  
  $catArticleHash.each do |category, articles|
    $currentCategoryObj = $currentStatementObj.categories.build(:name => category)
    
    articles.each do |article|
      @article = $currentCategoryObj.articles.build(:url => article)
      
      if @article.valid?
        @article.save
        Rails.logger.info 'Added article ' + @article.url
      end
    end
    
  if $currentCategoryObj.valid?  
    $currentCategoryObj.save
    Rails.logger.info 'Added category' + $currentCategoryObj.name
  end
            
  end
end

# Begin 'Main'
$grabber = ApiRequest.new

$issuesUrl.each do |key, value|
  $currentIssue = key  
  $issueResults = $grabber.getNextResults(value, false)

  processIssues($issueResults)
end