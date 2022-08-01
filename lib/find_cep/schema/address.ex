defmodule FindCep.Schema.Address do
  use Ecto.Schema
  import Ecto.Changeset

  schema "address" do
    field :cep, :string
    field :logradouro, :string
    field :complemento, :string
    field :bairro, :string
    field :localidade, :string
    field :uf, :string
    field :ibge, :string

    timestamps()
  end

  def changeset(address, params \\ %{}) do
    address
    |> cast(params, [:cep, :logradouro, :complemento, :bairro, :localidade, :uf, :ibge])
    |> validate_required([:cep])
  end
end
