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
      invoke options[:generator], arguments_for_generator_invocation(resource)
      # NaturalResourcesGenerator.remove_invocation options[:generator]
      puts "rails generate ingoweiss:scaffold #{arguments_for_generator_invocation(resource).join(' ')}"
    end
    route NaturalResources.routes_definition
  end
  
  # TODO: Need to figure out how to invoke generators with parsed ruby arguments:
  # invoke 'ingoweiss:scaffold', :post, {:title => :string}, :singleton => true, :skip_routes => true
  # until then, this method is used to convert to what the CLI expects:
  # invoke 'ingoweiss:scaffold', ['post', 'title:string', '--singleton', '--skip-routes']
  def arguments_for_generator_invocation(resource)
    resource_name, resource_attributes, resource_options = resource
    # puts [resource_name, resource_attributes.inspect, resource_options.inspect].join(' ')
    arguments = [resource_name.to_s]
    resource_attributes.each{|name, type| arguments << "#{name}:#{type}"}
    resource_options.merge(:skip_route => true).each{|name, value| arguments << option_for_generator_invocation(name, value)}
    arguments.compact
  end
  
  def option_for_generator_invocation(name, value)
    name = name.to_s.dasherize
    case value
    when TrueClass
      "--#{name}"
    when Array
      value.empty? ? nil : "--#{name}=#{value.join(' ')}"
    else
      "--#{name}=#{value}"
    end
  end
  
  def natural_resources_file_exists?
    File.exists?(File.join(destination_root, 'config/natural_resources.rb'))
  end
  
end