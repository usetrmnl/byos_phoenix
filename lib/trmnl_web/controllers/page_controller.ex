defmodule TrmnlWeb.PageController do
  use TrmnlWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/devices")
  end
end
