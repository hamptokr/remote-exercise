defmodule RemoteExercise.PointState do
  @moduledoc """
  Core set of functions to interact with a PointState
  """

  defstruct max_number: Enum.random(0..100),
            last_query: nil

  @type t :: %__MODULE__{
          max_number: 0..100,
          last_query: nil | DateTime.t()
        }

  @doc """
  Initialize a PointState, last_query will be nil until a query is done qith `query/2`
  """
  @spec new() :: t()
  def new() do
    %__MODULE__{
      max_number: Enum.random(0..100),
      last_query: nil
    }
  end

  @doc """
  This higher order function will return a tuple containing the result of
  `query_fn` and a point state with an updated query time. `query_fn` will be
  passed a PointState
  """
  @spec query(t(), (t() -> any())) :: {any(), t()}
  def query(%__MODULE__{} = state, query_fn) do
    {query_fn.(state), %{state | last_query: DateTime.utc_now()}}
  end

  @doc """
  Returns a PointState with an updated max_number
  """
  @spec randomize_max_number(t()) :: t()
  def randomize_max_number(%__MODULE__{} = state) do
    %{state | max_number: Enum.random(0..100)}
  end
end
