defmodule Trmnl.Screen do
  @moduledoc """
  Renders device screens.

  It is also the behaviour that modules must implement to be used as screens.
  """

  @callback render(assigns :: map) :: Phoenix.LiveView.Rendered.t()

  require Logger
  alias Trmnl.Inventory

  @width 800
  @height 480
  @color_depth 1

  # Determined experimentally... might change in the future!
  @chrome_extra_height 139

  @doc """
  Returns the playlist of screens to be displayed on the device.

  The result is a list of modules that implement the `Trmnl.Screen` behaviour.
  """
  def playlist(_device) do
    # The device argument could be used to customize the playlist
    [
      Trmnl.Screens.Hello
    ]
  end

  defp build_assigns(device) do
    # Customize this function to pass additional assigns to the screen
    %{
      device: device
    }
  end

  @doc """
  Regenerates the screen for the given device.

  This function is very slow because it calls out to the browser, so try to call it async whenever possible.

  ## Options

  - `:advance` - If `true`, advances the playlist before rendering.
  """
  def regenerate(device, opts \\ []) do
    # --- Determine the current screen module ---
    playlist = playlist(device)
    playlist_index = if opts[:advance], do: device.playlist_index + 1, else: device.playlist_index
    playlist_index = rem(playlist_index, length(playlist))
    screen = Enum.at(playlist, playlist_index)

    # --- Render the screen ---
    Logger.debug("Generating #{screen} for device #{device.id}...")
    assigns = %{device: device}
    {:ok, filename} = render_bmp(device, screen, build_assigns(assigns))

    # --- Update the device ---
    Inventory.update_device(device, %{
      latest_screen: filename,
      screen_generated_at: DateTime.utc_now(),
      playlist_index: playlist_index
    })
  end

  defp render_bmp(device, screen, assigns) do
    # --- Generate paths ---
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    basename = "screen_#{device.id}_#{timestamp}"
    glob = "screen_#{device.id}_*"

    screenshot_path =
      Path.join([:code.priv_dir(:trmnl), "..", "screenshots", "#{basename}.png"])

    generated_path =
      Path.join([:code.priv_dir(:trmnl), "static", "generated", "#{basename}.bmp"])

    generated_glob_path =
      Path.join([:code.priv_dir(:trmnl), "static", "generated", "#{glob}.bmp"])

    # --- Render the screen within the layout ---
    rendered =
      %{inner_content: screen.render(assigns)}
      |> TrmnlWeb.Layouts.screen()
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    temp_html_path =
      Path.join([:code.priv_dir(:trmnl), "static", "screens", "#{basename}.html"])

    File.write!(temp_html_path, rendered)

    # --- Fire up Chrome and take a screenshot ---
    {:ok, session} = Wallaby.start_session()

    session
    |> Wallaby.Browser.visit("/screens/#{basename}.html")
    |> Wallaby.Browser.resize_window(@width, @height + @chrome_extra_height)
    |> Wallaby.Browser.take_screenshot(name: basename)

    # --- Remove old screenshots ---
    generated_glob_path
    |> Path.wildcard()
    |> Enum.each(&File.rm!(&1))

    # --- Convert screenshot to BMP ---
    System.cmd("magick", [
      screenshot_path,
      "-resize",
      "#{@width}x#{@height}",
      "-dither",
      "FloydSteinberg",
      "-remap",
      "pattern:gray50",
      "-depth",
      "#{@color_depth}",
      "-strip",
      "-monochrome",
      "bmp3:#{generated_path}"
    ])

    # --- Remove temporary files ---
    File.rm!(temp_html_path)
    File.rm!(screenshot_path)

    {:ok, "#{basename}.bmp"}
  end
end
