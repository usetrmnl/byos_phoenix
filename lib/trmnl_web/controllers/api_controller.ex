defmodule TrmnlWeb.APIController do
  use TrmnlWeb, :controller

  require Logger

  alias Trmnl.Inventory

  def display(conn, _params) do
    with [api_key | _] <- get_req_header(conn, "access-token"),
         device = %Inventory.Device{} <- Inventory.get_device_by_api_key(api_key) do
      payload = %{
        status: 0,
        image_url: url(~p"/generated/#{device.latest_screen}"),
        filename: device.latest_screen,
        refresh_rate: device.refresh_interval,
        reset_firmware: false,
        update_firmware: false,
        firmware_url: nil,
        special_function: "sleep"
      }

      send_resp(conn, 200, Jason.encode!(payload))
    else
      _ ->
        payload = %{
          status: 500,
          error: "Device not found",
          reset_firmware: true
        }

        send_resp(conn, 200, Jason.encode!(payload))
    end
  end

  def setup(conn, _params) do
    with [mac_address | _] <- get_req_header(conn, "id"),
         device = %Inventory.Device{} <- Inventory.get_device_by_mac_address(mac_address) do
      payload = %{
        status: 200,
        api_key: device.api_key,
        friendly_id: device.friendly_id,
        image_url: url(~p"/images/setup/setup-logo.bmp"),
        message: "Welcome to TRMNL BYOS"
      }

      send_resp(conn, 200, Jason.encode!(payload))
    else
      _ ->
        payload = %{
          status: 404,
          api_key: nil,
          friendly_id: nil,
          image_url: nil,
          message: "MAC address not registered"
        }

        send_resp(conn, 200, Jason.encode!(payload))
    end
  end

  def log(conn, %{"log" => log}) do
    Logger.debug("/api/log: #{inspect(log)}")
    send_resp(conn, 200, "")
  end
end
