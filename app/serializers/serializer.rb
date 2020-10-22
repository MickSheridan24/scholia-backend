class Serializer
  def initialize(model)
    @model = model
  end

  def serialize_with_attributes(*attributes)
    ser = {}
    attributes.each { |a| ser[a] = @model[a] }
    ser
  end

  def serialized_with(member)
    ser = @model.serialized
    ser[member] = yield(@model.send(member))
    ser
  end

  def self.serialize_many_with(array, member)
    array.map { |element| element.serializer.serialized_with(member) { |m| yield m } }
  end

  def self.serialize_many(array)
    array.map { |a| a.serialized }
  end
end
