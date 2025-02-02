defmodule Trmnl.ScreenGenerator do
  @moduledoc """
  This GenServer is responsible for automatically generating all device screens every 15 minutes.

  It can also update a single device screen on demand.
  """
  use GenServer

  require Logger

  alias Trmnl.Screen
  alias Trmnl.Inventory

  @regenerate_interval 900_000

  # --- Public API ---

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def regenerate_asap(device) do
    GenServer.cast(__MODULE__, {:regenerate, device})
  end

  def counter() do
    GenServer.call(__MODULE__, :counter)
  end

  # --- GenServer callbacks ---

  @impl true
  def init(_) do
    send(self(), :regenerate_all)
    {:ok, %{counter: 0}}
  end

  @impl true
  def handle_cast({:regenerate, device}, state) do
    Screen.regenerate(device, state.counter)
    {:noreply, state}
  end

  @impl true
  def handle_call(:counter, _from, state) do
    {:reply, state.counter, state}
  end

  @impl true
  def handle_info(:regenerate_all, state) do
    Logger.debug("Regenerating all screens...")
    Process.send_after(self(), :regenerate_all, @regenerate_interval)

    # Could also spawn these Tasks in a TaskSupervisor to run fully async
    Inventory.list_devices()
    |> Task.async_stream(&Screen.regenerate(&1, state.counter))
    |> Stream.run()

    Logger.debug("All screens regenerated.")
    counter = state.counter + 1
    {:noreply, %{state | counter: counter}}
  end
end
