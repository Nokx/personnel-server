defmodule PersonnelServerWeb.PageController do
  use PersonnelServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
