defmodule Parser.Geolocations.Coordinate do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "coordinates" do
    field(:city, :string)
    field(:country, :string)
    field(:country_code, :string)
    field(:ip_address, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:mystery_value, :string)

    timestamps()
  end

  @fields ~w(ip_address country_code country city latitude longitude mystery_value)a

  @doc false
  def changeset(coordinate, attrs) do
    coordinate
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_number(:latitude, greater_than: -90, less_than: 90)
    |> validate_number(:longitude, greater_than: -180, less_than: 180)
    |> validate_ip()
    |> validate_country(:country)
    |> validate_country(:country_code)
    |> validate_country_and_code()
    |> validate_format(:city, ~r/^[A-Z a-z ][^0-9]*/)
    |> unique_constraint(:ip_address)
  end

  defp validate_ip(changeset) do
    changeset
    |> get_field(:ip_address)
    |> to_charlist()
    |> :inet.parse_address()
    |> case do
      {:ok, _} ->
        changeset

      _ ->
        add_error(changeset, :ip_address, "must be valid ip")
    end
  end

  defp validate_country(changeset, field) do
    value = get_field(changeset, field)

    if is_nil(country_name(value)) do
      add_error(changeset, field, "must be valid #{field}")
    else
      changeset
    end
  end

  defp validate_country_and_code(changeset) do
    country_code = changeset |> get_field(:country_code)
    country = changeset |> get_field(:country)

    if country_name(country_code) == country_name(country) do
      changeset
    else
      add_error(changeset, :country, "the country differs from the country code")
    end
  end

  defp country_name(value) do
    with false <- is_nil(value),
         :error <- Integer.parse(value) do
      get_country(value)
    else
      [] -> nil
      _ -> nil
    end
  end

  defp get_country(value) do
    try do
      Countries.get(value)
    rescue
      _ ->
        nil
    end
  end
end
