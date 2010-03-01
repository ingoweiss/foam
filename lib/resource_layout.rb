class ResourceLayout
   
  def initialize(&block)
    @scope = []
    self.instance_exec(&block)
  end
  
  class << self
    alias_method :define, :new
    
    def resources
      @@resources ||= []
    end
    
    def routes_definition
      @@route_definition ||= "\n"
    end
    
    def add_to_routes_definition(line, scope)
      routes_definition << ' '*(scope.length+2) + line + "\n"
    end
    
    def load(root)
      require root + '/config/resource_layout'
    end                                        
  end
  
  def many(resource, attributes={})
    current_scope = @scope.dup
    self.class.resources << [resource, attributes, {:scope => current_scope, :singleton => false}]
    if block_given?
      @scope << resource
      self.class.add_to_routes_definition "resources :#{resource}, :controller => '#{current_scope.collect{|s| s.to_s.singularize + '_'}.join}#{resource.to_s.pluralize}' do", current_scope
      yield
      self.class.add_to_routes_definition "end", current_scope
      @scope = current_scope
    else
      self.class.add_to_routes_definition "resources :#{resource}, :controller => '#{current_scope.collect{|s| s.to_s.singularize + '_'}.join}#{resource.to_s.pluralize}'", current_scope
    end
  end
  
  def one(resource, attributes={})
    current_scope = @scope.dup
    self.class.resources << [resource, attributes, {:scope => current_scope, :singleton => true}]
    if block_given?
      @scope << resource
      self.class.add_to_routes_definition "resource :#{resource}, :controller => '#{current_scope.collect{|s| s.to_s.singularize + '_'}.join}#{resource.to_s.singularize}' do", current_scope
      yield
      self.class.add_to_routes_definition "end", current_scope
      @scope = current_scope
    else
      self.class.add_to_routes_definition "resource :#{resource}, :controller => '#{current_scope.collect{|s| s.to_s.singularize + '_'}.join}#{resource.to_s.singularize}'", current_scope
    end
  end
  
end