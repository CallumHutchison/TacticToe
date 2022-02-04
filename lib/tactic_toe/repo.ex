defmodule TacticToe.Repo do
  use Ecto.Repo,
    otp_app: :tactic_toe,
    adapter: Ecto.Adapters.Postgres
end
