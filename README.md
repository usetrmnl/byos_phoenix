# TRMNL BYOS (Bring-Your-Own-Server) - Phoenix

This is a standalone ["bring-your-own-server"](https://docs.usetrmnl.com/go/diy/byos) for [TRMNL](https://usetrmnl.com/) devices.

Whether you have official TRMNL hardware or have [built your own](https://docs.usetrmnl.com/go/diy/byod), you can re-flash [the firmware](https://github.com/usetrmnl/firmware) and point at a self-hosted server like this one.

It's a standard Phoenix application with support for multiple TRMNL devices. A playlist rotates through a screen playlist, automatically advancing every 15 minutes. [puppeteer-img](https://www.npmjs.com/package/puppeteer-img) renders screens in a headless browser, and [ImageMagick](https://imagemagick.org/script/download.php) converts the screenshots to 1-bit bitmaps for display.

## Setup

Prerequisites:

- [puppeteer-img](https://www.npmjs.com/package/puppeteer-img)
- [ImageMagick](https://imagemagick.org/script/download.php)

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to add your first device.

## Modules to check out

- [Trmnl.Inventory.Device](lib/trmnl/inventory/device.ex) - Ecto schema
- [Trmnl.Inventory](lib/trmnl/inventory.ex) - device management
- [Trmnl.Playlist](lib/trmnl/playlist.ex) - device playlist management
- [Trmnl.Screen](lib/trmnl/screen.ex) - screen rendering
- [Trmnl.ScreenGenerator](lib/trmnl/screen_generator.ex) - GenServer for periodically re-rendering screens
- [Trmnl.Screens.HelloWorld](lib/trmnl/screens/hello_world.ex) - a basic example screen
- [TrmnlWeb.APIController](lib/trmnl_web/controllers/api_controller.ex) - the device endpoint
- [TrmnlWeb.ScreenController](lib/trmnl_web/controllers/screen_controller.ex) and [TrmnlWeb.ScreenHTML](lib/trmnl_web/controllers/screen_html.ex) - renders a device's current screen as HTML, which is screenshot by puppeteer-img

## Looking for another language?

- [usetrmnl/byos_sinatra](https://github.com/usetrmnl/byos_sinatra) (Ruby)
