defmodule FindCep.Repo do
  use Ecto.Repo,
    otp_app: :find_cep,
    adapter: Ecto.Adapters.Postgres
end
