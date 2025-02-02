defmodule Trmnl.Repo do
  use Ecto.Repo,
    otp_app: :trmnl,
    adapter: Ecto.Adapters.SQLite3
end
