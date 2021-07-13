defmodule RemoteExercise.UsersTest do
  use ExUnit.Case, async: false
  use RemoteExercise.DataCase
  alias RemoteExercise.User
  alias RemoteExercise.Users

  test "users are inserted with 0 points" do
    # Insert multiple users
    Repo.insert(%User{})
    Repo.insert(%User{})
    Repo.insert(%User{})

    Repo.all(User)
    |> Enum.each(fn u ->
      assert u.points == 0
    end)
  end

  test "randomize_points updates all points for all users" do
    {:ok, u1} = Repo.insert(%User{})
    {:ok, u2} = Repo.insert(%User{})
    assert u1.points == 0
    assert u2.points == 0

    Users.randomize_points()
    u1 = Repo.get(User, u1.id)
    u2 = Repo.get(User, u2.id)

    # Testing randomness is hard but the odds of both being randomized to 0 is
    # low. This should be fixed in the future
    assert u1.points != 0 or u2.points != 0
  end

  test "points_greater_than/1 returns 2 users when greater than max" do
    Repo.insert(%User{points: 51})
    Repo.insert(%User{points: 52})
    Repo.insert(%User{points: 53})

    assert length(Users.points_greater_than(50)) == 2
  end

  test "points_greater_than/1 can return only a single user" do
    Repo.insert(%User{points: 51})
    Repo.insert(%User{points: 49})
    Repo.insert(%User{points: 48})

    assert length(Users.points_greater_than(50)) == 1
  end

  test "points_greater_than/1 can return an empty list" do
    Repo.insert(%User{points: 51})
    Repo.insert(%User{points: 52})
    Repo.insert(%User{points: 53})

    assert length(Users.points_greater_than(54)) == 0
  end
end
