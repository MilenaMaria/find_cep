defmodule FindCepWeb.PageController do
  use FindCepWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
