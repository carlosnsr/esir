# Esir: ElasticSearch Indexed Restaurants

Proof of concept project.  Using Elixir, parses a CSV file of restaurant
information, and loads the restaurants into a local ElasticSearch instance.

One can then run a couple of queries of pre-coded queries on that index.

## Requirements

1. Install and run a local instance of ElasticSearch at http://localhost:9200 
(configured at lib/esir.ex)
1. Load up all restaurants, extracting only the id, name, full address, cuisine
and geo-location
1. Do a second pass, deleting any closed restaurants (i.e. have '- CLOSED' 
appended to their name
1. Implement the following queries:
    - restaurants that are near the Blinker office
    - all the German restaurants in California
    - restaurants with phone numbers that end in 1111

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `esir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:esir, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/esir](https://hexdocs.pm/esir).

