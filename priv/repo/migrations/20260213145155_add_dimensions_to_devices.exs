defmodule Trmnl.Repo.Migrations.AddDimensionsToDevices do
  use Ecto.Migration

  def change do
    alter table(:devices) do
      add :pixel_width, :integer, default: 800, null: false
      add :pixel_height, :integer, default: 480, null: false
    end
  end
end
