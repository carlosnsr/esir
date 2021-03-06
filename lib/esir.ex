defmodule Esir do
  @moduledoc """
  To run:
    Esir.run()
  """

  # elasticsearch url
  @url "http://localhost:9200"
  @index "restaurants"
  @filename "tmp/tripadvisor_in-restaurant_sample.csv"
  @doc_type "restaurant"

  alias Elastix.Index
  alias Elastix.Bulk
  alias Esir.Formatter
  alias Esir.Restaurant
  alias HTTPoison.Response

  def run do
    reset()
    initialize()
    index_restaurants()
    delete_closed_restaurants()
    :ok
  end

  def reset do
    case Index.delete(@url, @index) do
      {:ok, %Response{status_code: 200}} -> :ok
      {:ok, %Response{ body: %{"error" => %{"reason" => "no such index"}}} } -> :ok
    end
    initialize()
  end

  def initialize do
   case Index.exists?(@url, @index) do
     {:ok, true} -> :ok
     {:ok, false} -> set_up()
     _ -> :error
   end
  end

  defp set_up do
    Index.create(@url, @index, %{}) |> success?()
    mapping = Restaurant.mapping()
    Elastix.Mapping.put(@url, @index, @doc_type, mapping) |> success?()
    :ok
  end

  def index_restaurants do
    @filename
    |> Esir.Loader.parse()
    |> Stream.map(&Formatter.bulk_insert/1)
    |> Stream.chunk_every(1000)
    |> Enum.map(fn (list) ->
      Bulk.post(@url, List.flatten(list), index: @index, type: @doc_type)
    end)
  end

  def delete_closed_restaurants do
    @filename
    |> Esir.Loader.parse()
    |> Stream.filter(&Restaurant.closed?/1)
    |> Stream.map(&Formatter.bulk_delete/1)
    |> Stream.chunk_every(1000)
    |> Enum.map(fn (list) ->
      Bulk.post(@url, List.flatten(list), index: @index, type: @doc_type)
    end)
  end

  def run_search(query) do
    criteria = %{
      sort: [%{id: :asc}],
      size: 100,
      query: query
    }

    Elastix.Search.search(@url, @index, [@doc_type], criteria)
    |> get_body()
    |> get_hits()
    |> Enum.map(&show_hit/1)
  end

  defp success?({:ok, %Response{status_code: 200}}), do: :ok
  # purposefully left out other matches so that we get an error

  defp get_body({:ok, %Response{status_code: 200, body: body}}), do: body

  defp get_hits(%{"hits" => %{"hits" => hits}}), do: hits

  defp show_hit(%{
    "_source" => %{
      "id" => id,
      "name" => name,
      "address" => address,
      "phone" => phone
    }
  }) do
    %{id: id, name: name, address: address, phone: phone}
  end
end
