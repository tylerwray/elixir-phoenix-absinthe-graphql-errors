defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  import_types MyAppWeb.Schema.PaymentRequestTypes

  alias MyAppWeb.Resolvers

  query do
    field :ping, :string do
      resolve fn _, _, _ -> {:ok, "pong"} end
    end
  end

  mutation do
    @desc "Create a payment request"
    field :create_payment_request, :create_payment_request_result do
      arg :amount, non_null(:integer)
      @desc "The UID of the account from which to make the payment request"
      arg :account_uid, non_null(:id)
      arg :reader_uid, :id

      resolve &Resolvers.PaymentRequest.create/3
    end
  end
end
