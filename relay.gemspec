Gem::Specification.new do |gem|
  gem.name    = 'relay'
  gem.version = '0.0.3'
  gem.summary = ''
  gem.authors = ['Ingo Weiss']
  gem.summary = 'Generate scaffold for entire applications with arbitrarily nested resources'
  gem.description = 'Relay allows for generation of entire Rails apps from a single domain model'
  gem.email = 'ingo@ingoweiss.com'
  gem.homepage = 'http://www.github.com/ingoweiss'
  
  gem.files = Dir['lib/**/*']
  gem.add_dependency 'rails', '~> 3.0'
end