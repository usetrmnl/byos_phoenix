defmodule Trmnl.InventoryTest do
  use Trmnl.DataCase

  alias Trmnl.Inventory

  describe "devices" do
    alias Trmnl.Inventory.Device

    import Trmnl.InventoryFixtures

    @invalid_attrs %{name: nil, api_key: nil, mac_address: nil, friendly_id: nil, refresh_interval: nil}

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Inventory.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Inventory.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      valid_attrs = %{name: "some name", api_key: "some api_key", mac_address: "some mac_address", friendly_id: "some friendly_id", refresh_interval: 42}

      assert {:ok, %Device{} = device} = Inventory.create_device(valid_attrs)
      assert device.name == "some name"
      assert device.api_key == "some api_key"
      assert device.mac_address == "some mac_address"
      assert device.friendly_id == "some friendly_id"
      assert device.refresh_interval == 42
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      update_attrs = %{name: "some updated name", api_key: "some updated api_key", mac_address: "some updated mac_address", friendly_id: "some updated friendly_id", refresh_interval: 43}

      assert {:ok, %Device{} = device} = Inventory.update_device(device, update_attrs)
      assert device.name == "some updated name"
      assert device.api_key == "some updated api_key"
      assert device.mac_address == "some updated mac_address"
      assert device.friendly_id == "some updated friendly_id"
      assert device.refresh_interval == 43
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_device(device, @invalid_attrs)
      assert device == Inventory.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Inventory.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Inventory.change_device(device)
    end
  end
end
