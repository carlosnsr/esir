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
end
