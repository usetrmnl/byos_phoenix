defmodule Trmnl.Inventory do
  @moduledoc """
  Manages devices.
  """

  import Ecto.Query, warn: false

  alias Trmnl.Inventory.Device
  alias Trmnl.Repo

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  def get_device_by_mac_address(mac_address) do
    Repo.get_by(Device, mac_address: mac_address)
  end

  def get_device_by_api_key(api_key) do
    Repo.get_by(Device, api_key: api_key)
  end

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ default_attrs()) do
    %Device{}
    |> Device.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, device} ->
        Trmnl.ScreenGenerator.regenerate_asap(device)
        {:ok, device}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{data: %Device{}}

  """
  def change_device(%Device{} = device, attrs \\ default_attrs()) do
    Device.changeset(device, attrs)
  end

  def default_attrs do
    %{api_key: random_api_key(), friendly_id: random_friendly_id()}
  end

  def random_api_key do
    :crypto.strong_rand_bytes(12) |> Base.url_encode64()
  end

  def random_friendly_id do
    :crypto.strong_rand_bytes(3) |> Base.encode32(padding: false)
  end
end
