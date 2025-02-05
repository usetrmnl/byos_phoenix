# TRMNL BYOS (Bring-Your-Own-Server) - Phoenix

This is a standalone ["bring-your-own-server"](https://docs.usetrmnl.com/go/diy/byos) for [TRMNL](https://usetrmnl.com/) devices.

It's a standard Phoenix application with support for multiple TRMNL devices. A playlist rotates through multiple screens, regenerating them every 15 minutes. [Wallaby](https://github.com/elixir-wallaby/wallaby) is used to render screens in a headless Chrome browser.

Whether you have official TRMNL hardware or have [built your own](https://docs.usetrmnl.com/go/diy/byod), you can always re-flash [the firmware](https://github.com/usetrmnl/firmware) and point at your very own self-hosted server. This is a basic implementation of such a server.

## Setup

Prerequisites:

- [ImageMagick](https://imagemagick.org/script/download.php)
- [chromedriver](https://developer.chrome.com/docs/chromedriver/downloads)
- [Google Chrome](https://www.google.com/chrome/)

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser to add your first device.

## Modules to check out

- [Trmnl.Inventory.Device](lib/trmnl/inventory/device.ex) - Ecto schema
- [Trmnl.Inventory](lib/trmnl/inventory.ex) - device management
- [Trmnl.Screen](lib/trmnl/screen.ex) - screen rendering
- [Trmnl.ScreenGenerator](lib/trmnl/screen_generator.ex) - GenServer for periodically re-rendering screens
- [Trmnl.Screens.HelloWorld](lib/trmnl/screens/hello_world.ex) - a basic example screen
- [TrmnlWeb.APIController](lib/trmnl_web/controllers/api_controller.ex) - the device endpoint

## Looking for another language?

- [usetrmnl/byos_sinatra](https://github.com/usetrmnl/byos_sinatra) (Ruby)
