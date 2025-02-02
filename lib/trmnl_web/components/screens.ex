defmodule TrmnlWeb.Screens do
  @moduledoc """
  This module contains screens rendered for the TRMNL device.

  See the `screens` directory for all templates available.
  """
  use TrmnlWeb, :html

  embed_templates "screens/*"
end
