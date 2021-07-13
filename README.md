# RemoteExercise

This is an implementation of the exercise described [here](https://www.notion.so/Backend-code-exercise-d7df215ccb6f4d87a3ef865506763d50)

## Seeding your local database

Assuming you have elixir/mix/postgres installed, you can create and seed the
database with the following command. This will provide you with 1_000_000 users
with their `points` value initialized to 0.

```
mix ecto.setup
```

NOTE: Due to limits with postgres, we batch up the inserts into groups of 25_000
users

You can reset the database and re-seed the database with:

```
mix ecto.reset
```

## Running the Server

To start the server, make sure you have setup the database above, then run:

```
mix phx.server
```

With that running the server exposes a single endpoint at [http://localhost:4000](http://localhost:4000)

## Architecture

### Functional Core

The core set of functions for operating on a `PointState` are located in
`RemoteExercise.PointState`. The Boundary relies on this core but the separation
allows us to easily test each piece individually.

### Boundary

The `PointManager` is a GenServer that starts when the server starts. Every
minute this GenServer will spawn a task to update all 1_000_000 users point
values in the background. This task's result will be monitored and logged within
the GenServer. A task is used so that the API doesn't lockup while an update
occurs.

NOTE: On my machine the update occurs _usually_ in 2-4 seconds. There is a
configureable postgres query timeout that may need increased on your machine
(default 15 seconds).

### Tests

The test suite is located in the `test` folder and can be run with:

```
mix test
```
