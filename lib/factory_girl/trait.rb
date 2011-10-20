module FactoryGirl
  class Trait
    attr_reader :name

    def initialize(name, &block) #:nodoc:
      @name = name
      @attribute_list = AttributeList.new
      @block = block

      proxy = FactoryGirl::DefinitionProxy.new(self)
      proxy.instance_eval(&@block) if block_given?
    end

    def declare_attribute(declaration)
      @attribute_list.declare_attribute(declaration)
      declaration
    end

    def add_callback(name, &block)
      @attribute_list.add_callback(Callback.new(name, block))
    end

    def attributes
      AttributeList.new.tap do |list|
        @attribute_list.declarations.each {|declaration| list.declare_attribute(declaration) }
        list.compile_declarations

        list.apply_attributes @attribute_list
      end
    end

    def names
      [@name]
    end

    def ==(other)
      name == other.name &&
        block == other.block
    end

    protected
    attr_reader :block
  end
end
