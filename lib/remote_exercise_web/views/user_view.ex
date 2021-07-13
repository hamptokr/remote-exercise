defmodule RemoteExerciseWeb.UserView do
  use RemoteExerciseWeb, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, points: user.points}
  end
end
