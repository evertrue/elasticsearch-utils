# Elasticsearch::Utils

[![Gem Version](https://badge.fury.io/rb/elasticsearch-utils.svg)](http://badge.fury.io/rb/elasticsearch-utils)

Adds more cool methods to [`Elasticsearch::Client`](https://github.com/elasticsearch/elasticsearch-ruby) clients.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'elasticsearch-utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elasticsearch-utils

## Usage

### Streaming

For those times when you want to map over all results of a search (which may be very large, perhaps in a background job) and not worry about paging. This method leverages the [`scroll`](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/scan-scroll.html) feature of ElasticSearch to maximize server-side efficiency.

In this example, we run a search for all Bobs in the index and output their last name. There are a ton of bobs in Bobland so the deep paging would normally tax the server, so we opt to stream.

```
client = Elasticsearch::Client.new my_elasticsearch_config

search_body = {
  query: {
    match: {
      name_first: 'bob'
    }
  }
}

search_params = index: :bobland, type: :person, body: search_body

client.stream search_params do |doc|
  puts doc['name_last']
end
```

You can pass a `memo` variable to the block to track state in subsequent results. Stream will return the resulting memo.

```
bob_families = SortedSet.new
bob_families = client.stream search_params do |doc, bob_families|
  bob_families << doc['name_last']
end

puts "There are #{bob_families.count} families of bobs!"
```

To stop streaming, throw `:stop_stream` like so:

```
memo = client.stream search_params do |doc, memo|
  # If you are not using `memo`, you could also use `break`
  throw :stop_stream if memo > 10000

  # Use memo to count total results processed
  memo += 1
end

puts "Streamed #{memo} bobs!"
```

If sorting is not important for your query, even greater efficiency can be achieved by setting the `search_type` to `scan` like so:

```
search_params[:search_type] = :scan

client.stream search_params do |doc|
  # handle each bob out of order
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/elasticsearch-utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
