defmodule FindCep.Helpers do
  @moduledoc """
  Module responsible for internal manipulation functions such as
  queries and etc.
  """

  alias FindCep.Repo
  alias FindCep.Schema.Address

  def insert_address() do
    %Address{
      bairro: "",
      cep: "78360000",
      complemento: "",
      ibge: "0123456",
      id: 1,
      inserted_at: ~N[2022-07-27 22:35:42],
      localidade: "Campo Novo do Parecis",
      logradouro: "",
      uf: "MT",
      updated_at: ~N[2022-07-27 22:35:42]
    }
    |> Repo.insert!()
  end
end
