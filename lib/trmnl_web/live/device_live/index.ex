defmodule TrmnlWeb.DeviceLive.Index do
  use TrmnlWeb, :live_view

  alias Trmnl.Inventory
  alias Trmnl.Inventory.Device

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :devices, Inventory.list_devices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device")
    |> assign(:device, Inventory.get_device!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device")
    |> assign(:device, %Device{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Devices")
    |> assign(:device, nil)
  end

  @impl true
  def handle_info({TrmnlWeb.DeviceLive.FormComponent, {:saved, device}}, socket) do
    {:noreply, stream_insert(socket, :devices, device)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device = Inventory.get_device!(id)
    {:ok, _} = Inventory.delete_device(device)

    {:noreply, stream_delete(socket, :devices, device)}
  end
end
