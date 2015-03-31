# SimpleJsonApi::Rails

[![Gem Version](https://badge.fury.io/rb/simple_json_api-rails.svg)](http://badge.fury.io/rb/simple_json_api-rails)

A gem to render json following the [jsonapi](http://jsonapi.org) spec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_json_api-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_json_api-rails

## Usage

Depends on  [simple_json_api](https://github.com/ggordon/simple_json_api).

### Define serializers

A serializer will need to be created for each resource. The serializer will defined the attributes and associations of the serialized json.

```ruby
class ProjectSerializer < SimpleJsonApi::ResourceSerializer
  serializes :projects, model: Project
  attribute :id
  attribute :name, key: :project_name
  attribute :description
  attribute :position
  has_one :todolist
  has_many :tags
  def href
    "http://example.com/projects/#{_object.id}"
  end
end
```

Serializers are subclasses of `SimpleJsonApi::ResourceSerializer`. The `serializes` method defines the `root_class` for the object, specifying the model is optional, but may be necessary when the serializer cannot be determined for polymorphic associations.
`attribute` defines the attributes of the serializer, the optional `key` allows the name to be changed during serialization.
Associations are declared with `has_many`, `has_one`, and `belongs_to`. These can optionally set `polymorphic: true`. Also if the serializer cannot be determined by the name of the association, that is the name doesn't match any registered serializers, then the `serializer` parameter will need to be set.

### Using serializers

```ruby
render jsonapi: @projects,
                serializer: ProjectSerializer,
                fields: 'id,name',
                include: 'todolist'
```

When rendering the model is the AR data to be serialized, if it is an Array the ArraySerializer will be used for the top collection.
`fields` and `include` follow the jsonapi spec. [Include](http://jsonapi.org/format/#fetching-includes) will be the associations to be included in the generated json. [Fields](http://jsonapi.org/format/#fetching-sparse-fieldsets) is the list of attributes that will be included. The primary key will always be included.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple_json_api-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
