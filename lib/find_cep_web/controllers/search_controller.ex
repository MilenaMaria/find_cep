defmodule FindCepWeb.SearchController do
  use FindCepWeb, :controller

  alias FindCep.SearchCep

  def search(conn, %{"cep" => cep} = _params) do
    address = SearchCep.get_address_by_cep(cep)

    render(conn, "show.json", %{address: address})
  end

  def report_csv(conn, _params) do
    adresses = SearchCep.list_address()
    {:ok, pid} = Task.Supervisor.start_link()

    case adresses do
      [] ->
        Plug.Conn.put_status(conn, 204)

      adresses ->
        csv = SearchCep.build_csv(adresses)

        task =
          Task.Supervisor.async(pid, fn ->
            Phoenix.Controller.send_download(conn, {:binary, csv}, filename: "address.csv")
          end)

        Task.await(task)
    end
  end
end
