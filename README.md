# FindCep

O presente projeto é uma integração com a API Via Cep.

## Instalação

Clone o projeto

```bash
git clone https://github.com/MilenaMaria/find_cep.git
```

subir o ambiente docker

```bash
docker-compose up
```

para entrar no container do elixir

```bash
docker-compose run elixir bash
```

instalar as dependencias

```bash
mix deps.get
```

criar e migrar o banco de dados

```bash
mix ecto.setup
```

Iniciar o endpoint

```bash
mix phx.server
```

Abrir o terminal interativo

```bash
iex -S mix
```

ou ambos com

```bash
iex -S mix phx.server
```

## Teste utilizando o iex

```bash
mix test
```

## Rotas disponiveis

<http://localhost:4000/search/:cep>

`cep`: Número do cep

Rota responsavel pela busca do cep na base de dados e caso não exista
será buscado na base do ViaCep

<http://localhost:4000/report_csv>

gera um CSV de todos os endereços salvos
