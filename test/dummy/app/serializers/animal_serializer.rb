class AnimalSerializer < SimpleJsonApi::ResourceSerializer
  serializes :animals
  attribute :id
  attribute :common_name
end
