defmodule TacticToeWeb.PageController do
  use TacticToeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
