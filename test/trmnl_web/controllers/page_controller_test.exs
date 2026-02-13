defmodule TrmnlWeb.PageControllerTest do
  use TrmnlWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == "/devices"
  end
end
