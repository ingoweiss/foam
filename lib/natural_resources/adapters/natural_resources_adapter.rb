class NaturalResources
  module Adapters
    
    class NaturalResourcesAdapter
      def self.generate(resource, type, scope, attributes)
        puts "Generating #{type} #{resource} in scope #{scope.inspect} with attributes #{attributes.inspect}"
      end
    end
    
  end
end
