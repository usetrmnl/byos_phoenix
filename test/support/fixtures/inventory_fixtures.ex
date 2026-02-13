defmodule Trmnl.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trmnl.Inventory` context.
  """

  @doc """
  Generate a unique device friendly_id.
  """
  def unique_device_friendly_id, do: "some friendly_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique device mac_address.
  """
  def unique_device_mac_address, do: Enum.map(1..6, fn _ -> :rand.uniform(255) |> Integer.to_string(16) |> String.pad_leading(2, "0") end) |> Enum.join(":")

  @doc """
  Generate a device.
  """
  def device_fixture(attrs \\ %{}) do

    {:ok, device} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        friendly_id: unique_device_friendly_id(),
        mac_address: unique_device_mac_address(),
        name: "some name",
        refresh_interval: 42
      })
      |> Trmnl.Inventory.create_device()

    device
  end
end
