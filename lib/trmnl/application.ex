defmodule Trmnl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TrmnlWeb.Telemetry,
      Trmnl.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:trmnl, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:trmnl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Trmnl.PubSub},
      # Start a worker by calling: Trmnl.Worker.start_link(arg)
      # {Trmnl.Worker, arg},
      # Start to serve requests, typically the last entry
      TrmnlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trmnl.Supervisor]

    with {:ok, sup} <- Supervisor.start_link(children, opts) do
      Application.put_env(:wallaby, :base_url, TrmnlWeb.Endpoint.url())
      {:ok, sup}
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrmnlWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
