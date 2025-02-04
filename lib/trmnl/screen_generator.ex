defmodule Trmnl.ScreenGenerator do
  @moduledoc """
  This GenServer is responsible for automatically generating all device screens every 15 minutes.

  It can also update a single device screen on demand.
  """
  use GenServer

  require Logger

  alias Trmnl.Screen
  alias Trmnl.Inventory

  # 15 minutes
  @regenerate_interval 900_000

  # --- Public API ---

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Regenerates the screen for the given device as soon as possible.
  """
  def regenerate_asap(device) do
    GenServer.cast(__MODULE__, {:regenerate, device})
  end

  # --- GenServer callbacks ---

  @impl true
  def init(_) do
    send(self(), :advance_playlists)
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:regenerate, device}, state) do
    Screen.regenerate(device)
    {:noreply, state}
  end

  @impl true
  def handle_info(:advance_playlists, state) do
    Logger.debug("Regenerating all screens...")
    Process.send_after(self(), :advance_playlists, @regenerate_interval)

    # Could also spawn these Tasks in a TaskSupervisor to run fully async
    Inventory.list_devices()
    |> Task.async_stream(&Screen.regenerate(&1, advance: true))
    |> Stream.run()

    Logger.debug("All screens regenerated.")
    {:noreply, state}
  end
end
