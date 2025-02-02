defmodule Trmnl.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string, null: false
      add :mac_address, :string, null: false
      add :api_key, :string, null: false
      add :friendly_id, :string, null: false
      add :refresh_interval, :integer, null: false, default: 900

      timestamps(type: :utc_datetime)
    end

    create unique_index(:devices, [:friendly_id])
    create unique_index(:devices, [:mac_address])
  end
end
