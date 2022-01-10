defmodule Cloak.Ecto.TestComment do
  @moduledoc false

  use Ecto.Schema

  embedded_schema do
    field(:author, :string)
    field(:body, :string)
  end
end
