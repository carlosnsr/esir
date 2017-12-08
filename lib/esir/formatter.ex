defmodule Esir.Formatter do
  alias Esir.Restaurant

  def bulk_delete(%Restaurant{id: id}), do: [%{delete: %{_id: id}}]

  def bulk_insert(%Restaurant{id: id} = restaurant) do
    [%{index: %{_id: id}}, restaurant]
  end
end
