defmodule Cloak.Ecto.Type do
  @moduledoc false

  @callback __cloak__ :: Keyword.t()

  defmacro __using__(opts) do
    vault = Keyword.fetch!(opts, :vault)
    label = opts[:label]

    quote location: :keep do
      use Ecto.Type
      @behaviour Cloak.Ecto.Type

      @doc false
      @impl Ecto.Type
      def type, do: :binary

      @doc false
      @impl Ecto.Type
      def cast(nil) do
        {:ok, nil}
      end

      def cast(value) do
        {:ok, value}
      end

      @doc false
      @impl Ecto.Type
      def dump(nil) do
        {:ok, nil}
      end

      def dump(value) do
        case cast(value) do
          {:ok, value} -> maybe_encrypt_value(value)
          _otherwise -> :error
        end
      end

      @doc false
      @impl Ecto.Type
      def embed_as(_format) do
        :self
      end

      @doc false
      @impl Ecto.Type
      def equal?(term1, term2) do
        term1 == term2
      end

      @doc false
      @impl Ecto.Type
      def load(nil) do
        {:ok, nil}
      end

      def load(value) do
        case decrypt(value) do
          {:ok, value} ->
            value = after_decrypt(value)
            {:ok, value}

          _other ->
            :error
        end
      end

      @doc false
      def before_encrypt(value), do: to_string(value)

      @doc false
      def after_decrypt(value), do: value

      defoverridable after_decrypt: 1,
                     before_encrypt: 1,
                     cast: 1,
                     dump: 1,
                     embed_as: 1,
                     equal?: 2,
                     load: 1,
                     type: 0

      @doc false
      def __cloak__ do
        [vault: unquote(vault), label: unquote(label)]
      end

      defp maybe_encrypt_value(value) do
        if vault_started?(),
          do: encrypt_value(value),
          else: {:ok, value}
      end

      defp vault_started? do
        not_nil? = &(not is_nil(&1))

        unquote(vault)
        |> Process.whereis()
        |> not_nil?.()
      end

      defp encrypt_value(value) do
        with value <- before_encrypt(value),
             {:ok, value} <- encrypt(value) do
          {:ok, value}
        else
          _other ->
            :error
        end
      end

      defp encrypt(plaintext) do
        if unquote(label) do
          unquote(vault).encrypt(plaintext, unquote(label))
        else
          unquote(vault).encrypt(plaintext)
        end
      end

      defp decrypt(ciphertext) do
        unquote(vault).decrypt(ciphertext)
      end
    end
  end
end
