# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

# Postgres has a limit of 65535 parameters per query, to insert_all of the users
# we need to batch them up. 25_000 is currently an arbitrary number that yields
# 40 inserts total to end up with 1_000_000 users
batch_size = 25_000
# insert_all does not update timestamp fields, so we explicitly set them
now = DateTime.utc_now() |> DateTime.truncate(:second)

# This could break if future restrictions are made on the `users` table, e.g. a
# non-null field is added. For right now this is all that's required
List.duplicate(%{inserted_at: now, updated_at: now}, 1_000_000)
|> Enum.chunk_every(batch_size)
|> Enum.each(fn batch ->
  RemoteExercise.Repo.insert_all(RemoteExercise.User, batch)
end)
