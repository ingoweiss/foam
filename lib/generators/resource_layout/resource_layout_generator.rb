require 'resource_layout'

class ResourceLayoutGenerator < Rails::Generators::Base
  
  class_option :generator, :type => :string
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def run_generators_or_create_resource_layout_file
    resource_layout_file_exists? ? run_generators : create_resource_layout_file
  end
  
  protected
  
  def create_resource_layout_file
    if yes? 'Create resource layout file?'
      copy_file 'resource_layout_file.txt', 'config/resource_layout.rb'
    end
  end
  
  def run_generators
    ResourceLayout.load(destination_root)
    generator_class = Rails::Generators.find_by_namespace(options[:generator].to_s)
    ResourceLayout.resources.each do |(resource_name, resource_attributes, resource_options)|
      generator_class.new([resource_name, resource_attributes_array(resource_attributes)], resource_options.merge(:skip_route => true)).invoke_all
      sleep 1.1 # Hack to prevent 'Multiple migrations have the version number' errors
    end
    route ResourceLayout.routes_definition
  end
  
  def resource_attributes_array(resource_attributes)
    resource_attributes.collect{ |name, type| "#{name}:#{type}" }
  end

  def resource_layout_file_exists?
    File.exists?(File.join(destination_root, 'config/resource_layout.rb'))
  end
  
end