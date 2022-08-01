defmodule FindCep.Repo.Migrations.CreateTableAddress do
  use Ecto.Migration

  def up do
    create table("address") do
      add :cep, :string, size: 8
      add :logradouro, :string, null: true
      add :complemento, :string, null: true
      add :bairro, :string, null: true
      add :localidade, :string
      add :uf, :string, size: 2
      add :ibge, :string

      timestamps()
    end
  end

  def down do
    drop table("address")
  end
end
