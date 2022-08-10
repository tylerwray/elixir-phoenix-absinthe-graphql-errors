defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  import_types MyAppWeb.Schema.InvoiceTypes

  alias MyAppWeb.Resolvers

  query do
    field :ping, :string do
      resolve fn _, _, _ -> {:ok, "pong"} end
    end
  end

  mutation do
    @desc "Create an invoice"
    field :create_invoice, :create_invoice_result do
      arg :amount, non_null(:integer)
      @desc "The UID of the account from which to make the invoice"
      arg :account_uid, non_null(:id)
      arg :reader_uid, :id

      resolve &Resolvers.Invoices.create/3
    end
  end
end
