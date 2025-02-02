defmodule Trmnl.Screen do
  @width 800
  @height 480
  @color_depth 1

  # Determined experimentally... might change in the future!
  @chrome_extra_height 139

  def generate(device, heex_fun, assigns) do
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
      %{inner_content: heex_fun.(assigns)}
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
      "bmp3:#{generated_path}"
    ])

    # --- Remove temporary files ---
    File.rm!(temp_html_path)
    File.rm!(screenshot_path)

    {:ok, "/generated/#{basename}.bmp"}
  end
end
