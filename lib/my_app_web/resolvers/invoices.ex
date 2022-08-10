defmodule MyAppWeb.Resolvers.Invoices do
  alias MyApp.Invoices

  def create(_parent, params, _resolution) do
    case Invoices.create(params) do
      {:ok, invoice} ->
        {:ok, invoice}

      {:error, {:limit_reached, limit}} ->
        {:ok, %{limit: limit}}

      {:error, {:unavailable_reader, reader_status}} ->
        {:ok, %{reader_status: reader_status}}
    end
  end
end
