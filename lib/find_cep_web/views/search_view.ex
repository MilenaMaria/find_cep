defmodule FindCepWeb.SearchView do
  use FindCepWeb, :view

  def render("show.json", %{address: address}) do
    %{
      cep: address.cep,
      logradouro: address.logradouro,
      complemento: address.complemento,
      bairro: address.bairro,
      localidade: address.localidade,
      uf: address.uf,
      ibge: address.ibge,
      inserted_at: address.inserted_at,
      updated_at: address.updated_at
    }
  end
end
