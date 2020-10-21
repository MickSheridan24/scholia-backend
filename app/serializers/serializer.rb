module Serializer
  module Attributes
    @@add_attributes = []

    def attributes(*add_attributes)
      @@add_attributes = add_attributes
    end

    def has_many(obj, isSerialized)
      @@add_attributes << { object: obj, isSerialized: isSerialized }
    end
  end

  module Model
    attr_accessor :serialized
    attr_accessor :model

    def initialize(model)
      serialized = {}
      self.model = model
      compose_attributes
      compose_collections
    end

    def compose_attributes
      self.class.class_variable_get(:add_attributes)
          .select { |a| !a.is_a?(Hash) }
          .each do |a|
        serialized[a] = model[a]
      end
    end

    def compose_collections
      self.class.class_variable_get(:add_attributes)
          .select { |a| a.is_a?(Hash) }
          .each do |c|
        collection = model.send(c[:object])
        c[:isSerialized] && collection = collection.map { |s| s.serialized }
      end
    end
  end
end
