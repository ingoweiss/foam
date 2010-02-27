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
    ResourceLayout.resources.each do |resource|
      invoke options[:generator], arguments_for_generator_invocation(resource)
      # ResourceLayoutGenerator.remove_invocation options[:generator]
      puts "rails generate ingoweiss:scaffold #{arguments_for_generator_invocation(resource).join(' ')}"
    end
    route ResourceLayout.routes_definition
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
  
  def resource_layout_file_exists?
    File.exists?(File.join(destination_root, 'config/resource_layout.rb'))
  end
  
end