defmodule Trmnl.Playlist do
  alias Trmnl.Inventory

  @doc """
  Returns the playlist of screens to be displayed on the device.

  The result is a list of modules that implement the `Trmnl.Screen` behaviour.
  """
  def screens(_device) do
    # The device argument could be used to customize the playlist
    [
      Trmnl.Screens.HelloWorld
    ]
  end

  @doc """
  Returns the current screen module for the given device.
  """
  def current_screen(device) do
    # --- Determine the current screen module ---
    playlist = screens(device)
    playlist_index = rem(device.playlist_index, length(playlist))
    Enum.at(playlist, playlist_index)
  end

  @doc """
  Advances the playlist for the given device.
  """
  def advance(device) do
    {:ok, device} =
      Inventory.update_device(device, %{
        playlist_index: rem(device.playlist_index + 1, length(screens(device)))
      })

    device
  end
end
