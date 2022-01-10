defmodule Cloak.Ecto.Factory do
  @moduledoc false

  alias Cloak.Ecto.Hashed.HMAC
  alias Cloak.Ecto.{TestRepo, TestVault}

  @doc """
  Creates a user.
  """
  def create_user(email) do
    email = TestVault.encrypt!(email, :secondary)
    {:ok, email_hash} = HMAC.dump(email)

    {_count, [user]} =
      TestRepo.insert_all(
        "users",
        [
          %{
            name: "John Smith",
            email: email,
            email_hash: email_hash,
            inserted_at: DateTime.utc_now(),
            updated_at: DateTime.utc_now()
          }
        ],
        returning: [:id, :name, :email, :email_hash]
      )

    user
  end
end
