defmodule Trmnl.Screens.Hello do
  @moduledoc """
  A simple screen that says hello.
  """

  @behaviour Trmnl.Screen

  use Phoenix.Component

  def render(assigns) do
    assigns = Map.put(assigns, :generated_at, DateTime.utc_now())

    ~H"""
    <div class="text-2xl w-full h-full flex items-center justify-center">
      hello, I was rendered at {@generated_at}
    </div>
    """
  end
end
