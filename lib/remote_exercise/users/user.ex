defmodule RemoteExercise.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          points: 0..100,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :points, :integer, default: 0, null: false

    timestamps()
  end

  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:points])
    |> validate_number(:points, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> check_constraint(:points, name: :points_range, message: "points must be between 0 and 100")
  end
end
