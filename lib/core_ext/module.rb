module DynamicAttributes

  def self.included(klass)
    klass.instance_eval do
      def self.dynamic_attributes(*attributes)
        attributes.each do |attribute_name_as_sym|
          attribute_name = attribute_name_as_sym.to_s
         
          define_singleton_method attribute_name do
            instance_variable_get("@#{attribute_name}")
          end

          define_singleton_method "#{attribute_name}=" do |val|
            instance_variable_set("@#{attribute_name}", val)
          end
        end
      end
    end
  end
  
end