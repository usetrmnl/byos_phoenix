defmodule Trmnl.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string, null: false
      add :mac_address, :string, null: false
      add :api_key, :string, null: false
      add :friendly_id, :string, null: false
      add :refresh_interval, :integer, null: false, default: 900
      add :latest_screen, :string
      add :screen_generated_at, :utc_datetime
      add :alive_at, :utc_datetime
      add :playlist_index, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:devices, [:friendly_id])
    create unique_index(:devices, [:mac_address])
  end
end
