defmodule MyApp.Invoices do
  @doc """
  Context for Invoices.

  This is a simulated context function that can take fake
  arguments to simulate results.

  ## Examples

      iex> create(%{amount: 1000, account_uid: "limit_reached"})
      {:error, {:limit_reached, 1000}}

      iex> create(%{amount: 1000, account_uid: "b4ee876c-dc7a-43ac-88f0-71603a0ae594", reader_uid: "unavailable"})
      {:error, {:unavailable_reader, "requires_update"}}

      iex> create(%{amount: 1000, account_uid: "b4ee876c-dc7a-43ac-88f0-71603a0ae594"})
      {:ok,
       %{
         uid: "7a53a356-f426-48ba-9d17-3cd3add62c30",
         account_uid: account_uid,
         amount: amount,
         allowed_payment_methods: [:card, :bank_transfer]
       }}

  """
  def create(params) do
    %{amount: amount, account_uid: account_uid} = params

    reader_uid = Map.get(params, :reader_uid)

    cond do
      account_uid == "limit_reached" ->
        {:error, {:limit_reached, 1000}}

      reader_uid == "unavailable" ->
        {:error, {:unavailable_reader, "requires_update"}}

      true ->
        {:ok,
         %{
           uid: "7a53a356-f426-48ba-9d17-3cd3add62c30",
           account_uid: account_uid,
           amount: amount,
           allowed_payment_methods: [:card, :bank_transfer]
         }}
    end
  end
end
