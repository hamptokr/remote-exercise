defmodule RemoteExercise.Users do
  @moduledoc """
  The User context.

  Functions to interact with the `users` table in the database.
  """

  import Ecto.Query
  alias RemoteExercise.{Repo, User}

  @randomization_max 100

  @doc """
  This function will make a single SQL call to update all users with a random
  point value [0-100].

  In case of any errors the transaction will be rolled back and
  `{:error, failed_operation, failed_value, changes_so_far}` will be returned.
  """
  @spec randomize_points() :: {:ok, any()} | {:error, any(), any(), any()}
  def randomize_points do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(
      :randomize_points_update,
      update(User,
        set: [updated_at: ^now, points: fragment("floor(random()*(?))", @randomization_max + 1)]
      ),
      []
    )
    |> Repo.transaction()
  end

  @doc """
  Queries the database and returns at most 2 users with a point value higher
  than the given value
  """
  @spec points_greater_than(integer()) :: [%User{}]
  def points_greater_than(max) do
    User
    |> where([u], u.points > ^max)
    |> limit(2)
    |> Repo.all()
  end
end
