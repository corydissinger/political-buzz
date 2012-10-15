$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "apiinterface/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "apiinterface"
  s.version     = ApiInterface::VERSION
  s.authors     = ["Cory Dissinger"]
  s.summary     = "Summary of apiinterface."
  s.description = "Description of apiinterface."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
end
