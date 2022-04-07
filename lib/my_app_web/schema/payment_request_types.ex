defmodule MyAppWeb.Schema.PaymentRequestTypes do
  use Absinthe.Schema.Notation

  enum :payment_method, values: [:card, :bank_transfer, :bnpl]

  object :payment_request do
    field :uid, :id
    field :account_uid, :id
    field :amount, :integer
    field :payment_methods, list_of(:payment_method)
  end

  object :limit_reached do
    field :limit, :integer
  end

  object :unavailable_reader do
    field :reader_status, :string
  end

  union :create_payment_request_result do
    description "A result when creating a payment request"

    types [:payment_request, :limit_reached, :unavailable_reader]

    resolve_type fn
      %{uid: _}, _ -> :payment_request
      %{limit: _}, _ -> :limit_reached
      %{reader_status: _}, _ -> :unavailable_reader
    end
  end
end
