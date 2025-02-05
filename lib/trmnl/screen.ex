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

  @doc """
  Regenerates the screen for the given device.

  This function is very slow because it calls out to the browser, so try to call it async whenever possible.

  ## Options

  - `:advance` - If `true`, advances the playlist before rendering.
  """
  def regenerate(device) do
    # --- Render the screen ---
    Logger.debug("Generating screen for device #{device.id}...")
    screen_path = render_current_bmp(device)

    # --- Update the device ---
    Inventory.update_device(device, %{
      latest_screen: screen_path,
      screen_generated_at: DateTime.utc_now()
    })
  end

  # Hits the /screens/:api_key endpoint to get the current screen, then converts it to a BMP
  defp render_current_bmp(device) do
    # --- Generate paths ---
    screenshot_path = "temp-#{device.id}.png"
    basename = "d-#{device.id}"
    static_dir = Path.join([:code.priv_dir(:trmnl), "static", "generated"])
    static_path = Path.join([static_dir, "#{basename}.bmp"])
    current_screen_url = "#{TrmnlWeb.Endpoint.url()}/screens/#{device.api_key}"

    File.mkdir_p!(static_dir)

    # --- Generate screenshot ---
    System.cmd("puppeteer-img", [
      "--width",
      to_string(@width),
      "--height",
      to_string(@height),
      "--path",
      screenshot_path,
      current_screen_url
    ])

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
      "bmp3:#{static_path}"
    ])

    # --- Remove temporary files ---
    File.rm!(screenshot_path)

    # --- Return the path to the generated BMP ---
    "/generated/#{basename}.bmp"
  end
end
