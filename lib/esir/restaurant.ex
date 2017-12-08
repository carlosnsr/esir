defmodule Esir.Restaurant do
  defstruct \
      id: nil,
      name: nil,
      address: nil,
      phone: nil,
      city: nil,
      state: nil,
      country: nil,
      neighbourhood: nil,
      location: nil,
      cuisine: nil

  alias Esir.Restaurant

  def closed?(%Restaurant{name: name}) do
    String.ends_with?(name, "\n- CLOSED")
  end

  def mapping() do
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
        cuisine: %{type: "text"}
      }
    }
  end
end
