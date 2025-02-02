defmodule TrmnlWeb.APIController do
  use TrmnlWeb, :controller

  require Logger

  alias Trmnl.Inventory

  # GET /api/display
  def display(conn, _params) do
    with [api_key | _] <- get_req_header(conn, "access-token"),
         device = %Inventory.Device{} <- Inventory.get_device_by_api_key(api_key) do
      json(conn, display_ok(device))
    else
      _ -> json(conn, display_error())
    end
  end

  # GET /api/setup
  def setup(conn, _params) do
    with [mac_address | _] <- get_req_header(conn, "id"),
         device = %Inventory.Device{} <- Inventory.get_device_by_mac_address(mac_address) do
      json(conn, setup_ok(device))
    else
      _ -> json(conn, setup_error())
    end
  end

  # POST /api/log
  def log(conn, %{"log" => log}) do
    Logger.debug("/api/log: #{inspect(log)}")
    send_resp(conn, 200, "")
  end

  # --- JSON responses ---

  defp display_ok(device) do
    %{
      status: 0,
      image_url: url(~p"/generated/#{device.latest_screen}"),
      filename: device.latest_screen,
      refresh_rate: device.refresh_interval,
      reset_firmware: false,
      update_firmware: false,
      firmware_url: nil,
      special_function: "sleep"
    }
  end

  defp display_error do
    %{
      status: 500,
      error: "Device not found",
      reset_firmware: true
    }
  end

  defp setup_ok(device) do
    %{
      status: 200,
      api_key: device.api_key,
      friendly_id: device.friendly_id,
      image_url: url(~p"/images/setup/setup-logo.bmp"),
      message: "Welcome to TRMNL BYOS"
    }
  end

  defp setup_error do
    %{
      status: 404,
      api_key: nil,
      friendly_id: nil,
      image_url: nil,
      message: "MAC address not registered"
    }
  end
end
