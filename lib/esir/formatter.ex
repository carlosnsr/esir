defmodule Esir.Formatter do
  alias Esir.Restaurant

  def bulk_insert(%Restaurant{id: id} = restaurant) do
    [
      %{index: %{_id: id}},
      restaurant
    ]
  end

  def mapping(%Restaurant{} = _restaurant) do
    %{
      properties: %{
        id: %{type: "integer"},
        name: %{type: "text"},
        address: %{type: "text"},
        phone: %{type: "text"},
        city: %{type: "text"},
        state: %{type: "text"},
        country: %{type: "text"},
        neighbourhood: %{type: "text"},
        location: %{type: "geo_point"},
        cuisine: %{type: "text"},
        closed: %{type: "boolean"}
      }
    }
  end
end
