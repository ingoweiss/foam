# config/natural_resources.rb
# NaturalResources.generate do
#   
#   plural :posts => {:title => :string, :body => :text} do
#     plural :comments => {:body => :text}
#     singular :approval => {}
#   end
#   
# end



class NaturalResources
   
  def initialize(adapter=NaturalResources::Adapters::NaturalResourcesAdapter, &block)
    @scope = []                          
    @adapter = adapter
    self.instance_exec(&block)
  end
  
  class << self
    alias_method :generate, :new
  end
  
  def plural(resources)
    raise ArgumentError if block_given? and not resources.keys.one?
    resources.each do |resource, attributes|
      @adapter.generate(resource, :plural, @scope, attributes)
    end
    @scope << resources.keys.first and yield if block_given? 
  end
  
  def singular(resources)
    raise ArgumentError if block_given? and not resources.keys.one?
    resources.each do |resource, attributes|
      @adapter.generate(resource, :singular, @scope, attributes)
    end
    @scope << resources.keys.first and yield if block_given? 
  end
  
end