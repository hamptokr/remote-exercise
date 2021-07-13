defmodule RemoteExercise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RemoteExercise.Repo,
      # Start the Telemetry supervisor
      RemoteExerciseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RemoteExercise.PubSub},
      # Start the Endpoint (http/https)
      RemoteExerciseWeb.Endpoint,
      # Start a worker by calling: RemoteExercise.Worker.start_link(arg)
      # {RemoteExercise.Worker, arg}
      {Task.Supervisor, name: RemoteExercise.TaskSupervisor},
      {RemoteExercise.PointManager, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RemoteExercise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RemoteExerciseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
