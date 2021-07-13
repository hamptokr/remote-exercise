defmodule RemoteExercise.Repo do
  use Ecto.Repo,
    otp_app: :remote_exercise,
    adapter: Ecto.Adapters.Postgres
end
