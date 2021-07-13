defmodule RemoteExercise.PointManagerTest do
  use ExUnit.Case, async: false
  use RemoteExercise.DataCase
  alias RemoteExercise.PointManager

  @moduletag capture_log: true

  test "last_query is correctly updated on PointManager queries" do
    {_users, last_query} = PointManager.two_users_greater_than_max()
    assert last_query == nil

    {_users, last_query2} = PointManager.two_users_greater_than_max()
    assert last_query2 != nil
  end
end
