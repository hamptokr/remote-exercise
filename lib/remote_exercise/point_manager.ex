defmodule RemoteExercise.PointManager do
  use GenServer
  require Logger
  alias RemoteExercise.{PointState, Users}

  @doc """
  Returns _at most_ 2 users whose `points` value is greater than the current
  `max_number`.
  """
  @spec two_users_greater_than_max() :: {[%RemoteExercise.User{}], DateTime.t()}
  def two_users_greater_than_max() do
    GenServer.call(__MODULE__, :two_users_greater_than_max)
  end

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(_) do
    point_state = PointState.new()
    schedule_refresh()
    {:ok, point_state}
  end

  def handle_call(:two_users_greater_than_max, _from, point_state) do
    {users, updated_point_state} =
      PointState.query(point_state, fn p ->
        Users.points_greater_than(p.max_number)
      end)

    {:reply, {users, point_state.last_query}, updated_point_state}
  end

  def handle_info(:refresh_point_state, point_state) do
    # Unclear if I should _always_ update the max number or only when the point
    # update task completes successfully. For now it always updates immediately.
    #
    # NOTE: While the update processes, the 2 users returned will fluctuate but
    # they will always at minimum be above the max number set. This seems
    # acceptable given the requirements.
    point_state = PointState.randomize_max_number(point_state)

    # A GenServer handles messages sequentially. If we don't start a task,
    # messages will timeout while this large update occurs. From the user's POV
    # this results in timeouts in the JSON API while an update is occurring.
    # Using a task here means we can still send JSON API responses while also
    # updating the user point values in the background.
    Task.Supervisor.async_nolink(RemoteExercise.TaskSupervisor, &Users.randomize_points/0)
    Logger.info("Task to update all users has started.")

    # We schedule the next update here so that updates are indeed happening
    # every minute, but know that the update takes time and will complete a
    # little later.
    #
    # A postgres timeout is 15 seconds, so worst case the Task result will
    # contain an {:error, ...} which we handle by logging below.
    schedule_refresh()

    {:noreply, point_state}
  end

  # If we were handling more messages, we would need to make this match more
  # specific. For now this does the trick.
  def handle_info({ref, result}, point_state) do
    # The update task succeeded, cancel the monitoring and discard the :DOWN
    # message
    Process.demonitor(ref, [:flush])

    # The task completed successfully, lets check the actual postgres result
    case result do
      {:ok, _updated_users} ->
        Logger.info("Task to update users points finished successfully.")

      {:error, _failed_operation, _failed_value, _changes} ->
        Logger.error(
          "Failed to update user point values, may need to configure a larger postgrex timeout depending on machine"
        )
    end

    {:noreply, point_state}
  end

  def handle_info({:DOWN, _ref, _, _, reason}, point_state) do
    # The task failed for some reason. NOTE: This is a Task error, not
    # necessarily an error in query execution
    Logger.error("The user points update task failed with reason #{inspect(reason)}")
    {:noreply, point_state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh_point_state, :timer.minutes(1))
  end
end
