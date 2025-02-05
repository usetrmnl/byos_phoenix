defmodule TrmnlWeb.ScreenHTML do
  use TrmnlWeb, :html

  def show(%{screen: screen} = assigns) do
    screen.render(assigns)
  end
end
