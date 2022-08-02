defmodule FindCepWeb.Router do
  use FindCepWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FindCepWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :basic_auth, Application.compile_env(:find_cep, :basic_auth)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FindCepWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/search/:cep", SearchController, :search
    get "/report_csv", SearchController, :report_csv
  end

  # Other scopes may use custom stacks.
  # scope "/api", FindCepWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FindCepWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
