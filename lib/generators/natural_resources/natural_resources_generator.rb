class NaturalResourcesGenerator < Rails::Generators::Base
  
  class_option :generator, :type => :string, :default => 'ingoweiss:scaffold'
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def run_generators_or_create_natural_resources_file
    natural_resources_file_exists? ? run_generators : create_natural_resources_file
  end
  
  protected
  
  def create_natural_resources_file
    if yes? 'Create natural resources file?'
      copy_file 'natural_resources_file.txt', 'config/natural_resources.rb'
    end
  end
  
  def run_generators
    NaturalResources.load(destination_root)
    NaturalResources.resources.each do |resource|
      resource_name, resource_attributes, resource_options = resource
      puts [resource_name.inspect, resource_attributes.inspect, resource_options.inspect].join(' ')
      # invoke options[:generator], resource_name, resource_attributes, resource_options
      # IngoweissResourceGenerator.new.start(resource_name, resource_attributes, resource_options)
    end
    route NaturalResources.routes_definition
  end
  
  def natural_resources_file_exists?
    File.exists?(File.join(destination_root, 'config/natural_resources.rb'))
  end
  
end