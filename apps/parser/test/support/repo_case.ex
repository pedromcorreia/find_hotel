defmodule Parser.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Parser.Repo

      import Ecto
      import Ecto.Query
      import Parser.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Parser.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Parser.Repo, {:shared, self()})
    end

    :ok
  end
end
