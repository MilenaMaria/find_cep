defmodule FindCep.SearchCep do
  @moduledoc """
  Module responsible for internal manipulation functions such as
  queries and etc.
  """

  alias FindCep.Repo
  alias FindCep.Schema.Address

  @doc """
  Get an address by cep

  iex> get_address_by_cep(7836000)
  %FindCep.Schema.Address{
    __meta__: #Ecto.Schema.Metadata<:loaded, "address">,
    bairro: "",
    cep: "78360000",
    complemento: "",
    ibge: "5102637",
    id: 2,
    inserted_at: ~N[2022-07-27 22:35:42],
    localidade: "Campo Novo do Parecis",
    logradouro: "",
    uf: "MT",
    updated_at: ~N[2022-07-27 22:35:42]
  }
  """
  def get_address_by_cep(cep) do
    case get_address(cep) do
      nil -> make_request_address_by_cep(cep)
      address -> address
    end
  end

  @doc """
  Create a csv with all saved addresses
   iex> build_csv([
               "cep,logradouro,complemento,bairro,localidade,uf,ibge\r\n",
               "12360000,,,,Cidade Teste,MT,0123456\r\n"
             ])
  """
  def build_csv(adresses) when is_list(adresses) do
    headers = ["cep", "logradouro", "complemento", "bairro", "localidade", "uf", "ibge"]

    adresses
    |> parse_addres_csv()
    |> CSV.encode(headers: headers)
    |> Enum.map(& &1)
  end

  @doc """
  Returns a list of addresses
  iex> list_address()
  [
      %FindCep.Schema.Address{
      __meta__: #Ecto.Schema.Metadata<:loaded, "address">,
      bairro: "",
      cep: "78360000",
      complemento: "",
      ibge: "5102637",
      id: 2,
      inserted_at: ~N[2022-07-27 22:35:42],
      localidade: "Campo Novo do Parecis",
      logradouro: "",
      uf: "MT",
      updated_at: ~N[2022-07-27 22:35:42]
    }
  ]
  """
  def list_address() do
    Repo.all(Address)
  end

  defp get_address(cep) do
    Repo.get_by(Address, cep: cep)
  end

  defp make_request_address_by_cep(cep) do
    {:ok, request} = HTTPoison.get("https://viacep.com.br/ws/#{cep}/json/")

    if String.contains?(request.body, "erro") do
      :error
    else
      insert_address(request.body)
    end
  end

  defp insert_address(address) do
    params =
      address
      |> Jason.decode!()
      |> parse_address()

    %Address{} |> Address.changeset(params) |> Repo.insert!()
  end

  defp parse_address(address) do
    cep = String.replace(address["cep"], "-", "")

    %{
      cep: cep,
      logradouro: address["logradouro"],
      complemento: address["complemento"],
      bairro: address["bairro"],
      localidade: address["localidade"],
      uf: address["uf"],
      ibge: address["ibge"]
    }
  end

  defp parse_addres_csv(adresses) do
    Enum.map(adresses, fn address ->
      %{
        "cep" => address.cep,
        "logradouro" => address.logradouro,
        "complemento" => address.complemento,
        "bairro" => address.bairro,
        "localidade" => address.localidade,
        "uf" => address.uf,
        "ibge" => address.ibge
      }
    end)
  end
end
