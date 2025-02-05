defmodule TrmnlWeb.ScreenController do
  use TrmnlWeb, :controller

  alias Trmnl.Screen
  alias Trmnl.Inventory

  plug :put_root_layout, html: {TrmnlWeb.Layouts, :screen}
  plug :put_layout, false

  def show(conn, %{"api_key" => api_key}) do
    device = Inventory.get_device_by_api_key(api_key)
    screen = Screen.current_screen(device)

    assigns = %{
      # Put any additional assigns here!
      device: device,
      screen: screen
    }

    render(conn, :show, assigns)
  end
end
