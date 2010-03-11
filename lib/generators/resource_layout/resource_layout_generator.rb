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
    ResourceLayout.resources.each do |resource|
      # (1) generator_class.start(arguments_for_generator_invocation(resource))
      # does not parse --scope option array properly
      # (2) resource_name, resource_attributes, resource_options = resource
      # generator_class.new([resource_name, resource_attributes], resource_options).invoke
      # does not handle ruby hash as attributes properly ('named_base.rb' messes this up)
      # (3) so...
      Dir.chdir(destination_root) do
        %x[rails generate ingoweiss:scaffold #{arguments_for_generator_invocation(resource).join(' ')}]
      end
      sleep 1.1 # Hack to prevent 'Multiple migrations have the version number' errors
    end
    route ResourceLayout.routes_definition
  end
  
  # TODO: Need to figure out how to invoke generators with parsed ruby arguments:
  # invoke 'ingoweiss:scaffold', :post, {:title => :string}, :singleton => true, :skip_routes => true
  # until then, this method is used to convert to what the CLI expects:
  # invoke 'ingoweiss:scaffold', ['post', 'title:string', '--singleton', '--skip-routes']
  def arguments_for_generator_invocation(resource)
    resource_name, resource_attributes, resource_options = resource
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