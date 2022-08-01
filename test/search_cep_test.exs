defmodule FindCep.SearchCepTest do
  use ExUnit.Case

  alias FindCep.Helpers
  alias FindCep.Schema.Address
  alias FindCep.SearchCep

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FindCep.Repo)
  end

  describe "get_address_by_cep/1" do
    test "search for an address by zip code" do
      Helpers.insert_address()

      assert Enum.count(SearchCep.list_address()) == 1

      assert %Address{} = SearchCep.get_address_by_cep("78360000")

      assert Enum.count(SearchCep.list_address()) == 1
    end

    test "when you don't find an address save the searched" do
      assert Enum.count(SearchCep.list_address()) == 0

      assert %Address{} = SearchCep.get_address_by_cep("78360000")

      assert Enum.count(SearchCep.list_address()) == 1
    end

    test "returns error when zip code is not found" do
      assert :error = SearchCep.get_address_by_cep("78360800")
    end
  end

  describe "list_address/0" do
    test "returns a list of addresses" do
      address = Helpers.insert_address()

      assert SearchCep.list_address() == [address]
    end

    test "returns an empty list when there is no data" do
      assert SearchCep.list_address() == []
    end
  end

  describe "build_csv/2" do
    test "returns an empty list when there is no data" do
      assert [] == SearchCep.build_csv([])
    end

    test "returns parsed data when it has data" do
      address = Helpers.insert_address()

      assert [
               "cep,logradouro,complemento,bairro,localidade,uf,ibge\r\n",
               "78360000,,,,Campo Novo do Parecis,MT,0123456\r\n"
             ] == SearchCep.build_csv([address])
    end
  end
end
