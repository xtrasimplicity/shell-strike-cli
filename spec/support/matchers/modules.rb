require 'rspec/expectations'

RSpec::Matchers.define :have_getter_and_setter_methods_for do |attribute_name_as_sym|

  match do |obj|
    object_responds_to_methods?(obj, attribute_name_as_sym) && setter_and_getter_methods_function?(obj, attribute_name_as_sym)
  end

  def object_responds_to_methods?(obj, attribute_name_as_sym)
    obj.respond_to?(attribute_name_as_sym) && 
    obj.respond_to?("#{attribute_name_as_sym}=")
  end

  def setter_and_getter_methods_function?(obj, attribute_name_as_sym)
    obj.send("#{attribute_name_as_sym}=", :test)

    obj.send(attribute_name_as_sym) == :test
  end


end