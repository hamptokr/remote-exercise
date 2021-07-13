defmodule RemoteExerciseWeb.PointView do
  use RemoteExerciseWeb, :view
  alias RemoteExerciseWeb.UserView

  def render("two_users_greater_than_max.json", %{users: users, timestamp: timestamp}) do
    %{users: render_many(users, UserView, "user.json"), timestamp: timestamp}
  end
end
