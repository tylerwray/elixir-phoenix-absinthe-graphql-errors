defmodule MyAppWeb.Schema.InvoiceTypes do
  use Absinthe.Schema.Notation

  enum :payment_method, values: [:card, :bank_transfer, :bnpl]

  object :invoice do
    field :uid, :id
    field :account_uid, :id
    field :amount, :integer
    field :allowed_payment_methods, list_of(:payment_method)
  end

  object :limit_reached do
    field :limit, :integer
  end

  object :unavailable_reader do
    field :reader_status, :string
  end

  union :create_invoice_result do
    description "A result when creating an invoice"

    types [:invoice, :limit_reached, :unavailable_reader]

    resolve_type fn
      %{uid: _}, _ -> :invoice
      %{limit: _}, _ -> :limit_reached
      %{reader_status: _}, _ -> :unavailable_reader
    end
  end
end
