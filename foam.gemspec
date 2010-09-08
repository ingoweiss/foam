Gem::Specification.new do |gem|
  gem.name    = 'foam'
  gem.version = '0.0.5'
  gem.summary = ''
  gem.authors = ['Ingo Weiss']
  gem.summary = 'A scaffold meta-generator'
  gem.description = 'Foam is a meta generator for generating scaffold for a Rails application from a description of the application\'s resource layout'
  gem.email = 'ingo@ingoweiss.com'
  gem.homepage = 'http://www.github.com/ingoweiss/foam'
  
  gem.files = Dir['lib/**/*']
  gem.add_dependency 'rails', '3.0.0'
  gem.add_development_dependency 'ingoweiss_generators', '0.0.6'
end