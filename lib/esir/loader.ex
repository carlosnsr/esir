defmodule Esir.Loader do
  @moduledoc """
    Module that encapsulates the receipt of a CSV file of restaurant data,
    and its parsing and moulding

    The CSV should have the following columns:
    - Restaurant ID
    - Restaurant URL
    - Name
    - Address
    - Phone
    - City
    - State
    - Country
    - Neighbourhood
    - Email ID
    - Menu
    - Website
    - Latitude
    - Longitude
    - About Restaurant
    - Cuisine
    - Good for(suitable)
    - Price
    - Currency
    - Rating
    - Ranking
    - Deal(Promotion)
    - Total Review
    - Last Reviewed
    - Recommended
    - Dining Option
    - Award
    - Uniq Id

    We only extract the following columns:
    - Restaurant ID
    - Name
    - Address
    - Phone
    - City
    - State
    - Country
    - Neighbourhood
    - Latitude & Longitude as a geolocation(look in the meeting invite for more details)
    - Cuisine
  """

  def parse(filename) do
    filename
    |> File.stream!(read_ahead: 100_000)
    |> NimbleCSV.RFC4180.parse_stream
    |> Stream.map(&mould/1)
  end

  defp mould([
    restaurant_id,
    _restaurant_url,
    name,
    address,
    phone,
    city,
    state,
    country,
    neighbourhood,
    _email_id,
    _menu,
    _website,
    latitude,
    longitude,
    _about,
    cuisine
    | _]
  ) do
    %Esir.Restaurant{
      id: restaurant_id,
      name: name,
      address: address,
      phone: phone,
      city: city,
      state: state,
      country: country,
      neighbourhood: neighbourhood,
      latitude: latitude,
      longitude: longitude,
      cuisine: cuisine
    }
  end
end
