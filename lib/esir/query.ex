defmodule Esir.Query do
  import Esir, only: [run_search: 1]

  def restaurants_near_office do
    query = %{
      bool: %{
        must: %{ match_all: %{} },
        filter: %{
          geo_distance: %{
            distance: "16km",
            location: %{
              lat: 39.7501158,
              lon: -104.9989422
            }
          }
        }
      }
    }

    run_search(query)
  end

  def german_restaurants_in_california do
    query = %{
      bool: %{
        must: [
          %{ match: %{ state: "CA" }},
          %{ match: %{ cuisine: "German" }}
        ]
      }
    }

    run_search(query)
  end

  def restaurants_with_phone_numbers_ending_1111 do
    query = %{
      regexp: %{ phone: ".*1111" }
    }

    run_search(query)
  end
end
