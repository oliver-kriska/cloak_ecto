defmodule Cloak.Ecto.Encrypted.Binary do
  @moduledoc false

  use Cloak.Ecto.Binary, vault: Cloak.Ecto.TestVault
end
