defmodule TrmnlWeb.DeviceLive.Show do
  use TrmnlWeb, :live_view

  alias Trmnl.Inventory
  alias Trmnl.Screen

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:device, Inventory.get_device!(id))
     |> assign(:screen_at, DateTime.to_unix(DateTime.utc_now()))}
  end

  @impl true
  def handle_event("regenerate", _, socket) do
    {:ok, device} = Screen.regenerate(socket.assigns.device)
    {:noreply, assign(socket, device: device, screen_at: DateTime.to_unix(DateTime.utc_now()))}
  end

  defp page_title(:show), do: "Show Device"
  defp page_title(:edit), do: "Edit Device"
end
