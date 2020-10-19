class Serializer
    attr_accessor :serialized
    attr_accessor :model
    @@attributes = []


    def initialize model
        self.serialized = {}
        self.model = model 
        compose_attributes
        compose_collections
    end

    def self.attributes *attributes
        @@attributes = attributes
    end

    def self.has_many (obj, isSerialized)
        @@attributes << {object: obj, isSerialized: isSerialized}
    end

    private

    def compose_attributes 
        @@attributes.select { |a| !a.is_a?(Hash) }.each do |a| 
           serialized[a] = model[a]
        end
    end

    def compose_collections
        @@attributes.select { |a| a.is_a?(Hash)}.each do |c| 
            collection = model.send(c[:object])
            c[:isSerialized] && collection = collection.map{ |s| s.serialized }
        end
    end
end