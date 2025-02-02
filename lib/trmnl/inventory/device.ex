defmodule Trmnl.Inventory.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string, default: "My TRMNL"
    field :api_key, :string
    field :mac_address, :string
    field :friendly_id, :string
    field :refresh_interval, :integer, default: 900

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :mac_address, :api_key, :friendly_id, :refresh_interval])
    |> upcase([:friendly_id, :mac_address])
    |> validate_required([:name, :mac_address, :api_key, :friendly_id, :refresh_interval])
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
