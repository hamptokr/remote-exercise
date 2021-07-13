defmodule RemoteExercise.PointStateTest do
  use ExUnit.Case, async: true
  alias RemoteExercise.PointState

  test "a PointState is initilized with correct data" do
    ps = PointState.new()
    assert ps.max_number >= 0
    assert ps.max_number <= 100
    assert ps.last_query == nil
  end

  test "a PointState max_number is randomized" do
    ps = PointState.new()
    r1 = ps.max_number
    r2 = ps |> PointState.randomize_max_number() |> Map.fetch!(:max_number)
    r3 = ps |> PointState.randomize_max_number() |> Map.fetch!(:max_number)

    # Testing randomness is hard but the odds of this happening are slim. Really
    # we just want to verify that the value was updated. There has to be a
    # better way to test this
    assert r1 != r2 != r3
  end

  test "the query_fn in query/2 is correctly passed a point state" do
    outer_ps = PointState.new()

    PointState.query(outer_ps, fn inner_ps ->
      # The outer and inner PointStates should be the same
      assert outer_ps.max_number == inner_ps.max_number
    end)
  end

  test "last_query is updated when query/2 is called" do
    ps = PointState.new()

    {_res, %PointState{last_query: q1_time} = ps2} =
      PointState.query(ps, fn _ ->
        assert true
      end)

    # To guarentee we get a different timestamp, we sleep for 1ms, unnoticable
    Process.sleep(1)

    {_res, %PointState{last_query: q2_time}} =
      PointState.query(ps2, fn _ ->
        assert true
      end)

    assert DateTime.compare(q2_time, q1_time) == :gt
  end
end
