defmodule MyAppWeb.Resolvers.PaymentRequest do
  alias MyApp.Payments

  def create(_parent, params, _resolution) do
    case Payments.create_payment_request(params) do
      {:ok, payment_request} ->
        {:ok, payment_request}

      {:error, {:limit_reached, limit}} ->
        {:ok, %{limit: limit}}

      {:error, {:unavailable_reader, reader_status}} ->
        {:ok, %{reader_status: reader_status}}
    end
  end
end
