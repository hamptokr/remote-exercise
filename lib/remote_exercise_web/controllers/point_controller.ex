defmodule RemoteExerciseWeb.PointController do
  use RemoteExerciseWeb, :controller
  alias RemoteExercise.PointManager

  def two_users_greater_than_max(conn, _params) do
    {users, last_query} = PointManager.two_users_greater_than_max()
    render(conn, "two_users_greater_than_max.json", users: users, timestamp: last_query)
  end
end
