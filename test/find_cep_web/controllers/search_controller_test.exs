defmodule FindCepWeb.SearchControllerTest do
  use FindCepWeb.ConnCase

  import Plug.BasicAuth

  alias FindCep.Helpers
  alias FindCep.Schema.Address

  describe "search/2" do
    test "does not allow consultation with unauthenticated user ", %{conn: conn} do
      conn = get(conn, "/search/78360000")

      assert conn.status == 401
    end

    test "search for an address by zip code", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", encode_basic_auth("hello", "secret"))
        |> get("/search/78360000")

      address = %Address{
        bairro: nil,
        cep: "78360000",
        complemento: nil,
        ibge: "5102637",
        localidade: "Campo Novo do Parecis",
        logradouro: nil,
        uf: "MT"
      }

      result = conn.assigns.address
      assert address.cep == result.cep
      assert address.complemento == result.complemento
      assert address.ibge == result.ibge
      assert address.localidade == result.localidade
      assert address.uf == result.uf
    end
  end

  describe "report_csv/2" do
    test "does not allow consultation with unauthenticated user ", %{conn: conn} do
      conn = get(conn, "/report_csv")

      assert conn.status == 401
    end

    test "returns status 204 when there is no data to download", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", encode_basic_auth("hello", "secret"))
        |> get("/report_csv")

      assert conn.status == 204
    end

    test "requests to download address list", %{conn: conn} do
      Helpers.insert_address()

      conn =
        conn
        |> put_req_header("authorization", encode_basic_auth("hello", "secret"))
        |> get("/report_csv")

      resp_headers = conn.resp_headers

      assert [
               _,
               _,
               _,
               _,
               _,
               _,
               _,
               _,
               {"content-type", "text/csv"},
               {"content-disposition", "attachment; filename=\"address.csv\""}
             ] = resp_headers
    end
  end
end
