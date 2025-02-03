defmodule Trmnl.Inventory.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :alive_at, :utc_datetime
    field :api_key, :string
    field :friendly_id, :string
    field :latest_screen, :string
    field :mac_address, :string
    field :name, :string, default: "My TRMNL"
    field :playlist_index, :integer, default: 0
    field :refresh_interval, :integer, default: 900
    field :screen_generated_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [
      :alive_at,
      :api_key,
      :friendly_id,
      :latest_screen,
      :mac_address,
      :name,
      :playlist_index,
      :refresh_interval,
      :screen_generated_at
    ])
    |> upcase([:friendly_id, :mac_address])
    |> validate_required([
      :api_key,
      :friendly_id,
      :mac_address,
      :name,
      :playlist_index,
      :refresh_interval
    ])
    |> validate_mac_address()
    |> unique_constraint(:friendly_id)
    |> unique_constraint(:mac_address)
  end

  defp validate_mac_address(changeset) do
    validate_format(changeset, :mac_address, ~r/^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$/)
  end

  defp upcase(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      update_change(changeset, field, &String.upcase/1)
    end)
  end
end
