defmodule Esir do
  @moduledoc """
  To run:
    Esir.reset
    Esir.initialize
    Esir.index_restaurants
  """

  # elasticsearch url
  @url "http://localhost:9200"
  @index "restaurants"
  @filename "tmp/tripadvisor_in-restaurant_sample.csv"
  @doc_type "restaurant"

  alias Elastix.Index
  alias Esir.Formatter

  def reset do
    case Index.delete(@url, @index) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, %HTTPoison.Response{body: %{"error" => %{"reason" => "no such index"}}}} -> :ok
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
    {:ok, %HTTPoison.Response{status_code: 200}} = Index.create(@url, @index, %{})

    mapping = Formatter.mapping(%Esir.Restaurant{})
    {:ok, %HTTPoison.Response{status_code: 200}} =
      Elastix.Mapping.put(@url, @index, @doc_type, mapping)

    :ok
  end

  def index_restaurants do
    @filename
    |> Esir.Loader.parse()
    |> Stream.map(&Formatter.bulk_insert/1)
    |> Stream.chunk_every(1000)
    |> Enum.map(fn (list) ->
      Elastix.Bulk.post(@url, List.flatten(list), index: @index, type: @doc_type)
    end)
  end
end
