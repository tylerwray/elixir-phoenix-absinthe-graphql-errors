defmodule MyAppWeb.GraphQLTest do
  use MyAppWeb.ConnCase, async: true

  test "returns a payment request", %{conn: conn} do
    mutation = """
    mutation CreatePaymentRequest($accountUid: ID!, $amount: Int!) {
      createPaymentRequest(accountUid: $accountUid, amount: $amount) {
        ... on PaymentRequest {
          uid
          amount
          accountUid
          paymentMethods
        }
        ... on LimitReached {
          limit
        }
        __typename
      }
    }
    """

    variables = %{"accountUid" => "35db6b7e-9493-4474-916f-37c04a137a86", "amount" => 123_000}

    body =
      conn
      |> post("/graphql", %{query: mutation, variables: variables})
      |> json_response(200)

    assert %{
             "data" => %{
               "createPaymentRequest" => %{
                 "uid" => "7a53a356-f426-48ba-9d17-3cd3add62c30",
                 "amount" => 123_000,
                 "accountUid" => "35db6b7e-9493-4474-916f-37c04a137a86",
                 "paymentMethods" => ["CARD", "BANK_TRANSFER"],
                 "__typename" => "PaymentRequest"
               }
             }
           } = body
  end

  test "returns limit reached result", %{conn: conn} do
    mutation = """
    mutation CreatePaymentRequest($accountUid: ID!, $amount: Int!) {
      createPaymentRequest(accountUid: $accountUid, amount: $amount) {
        ... on PaymentRequest {
          uid
          amount
          accountUid
          paymentMethods
        }
        ... on LimitReached {
          limit
        }
        __typename
      }
    }
    """

    variables = %{"accountUid" => "limit_reached", "amount" => 123_000}

    body =
      conn
      |> post("/graphql", %{query: mutation, variables: variables})
      |> json_response(200)

    assert %{
             "data" => %{
               "createPaymentRequest" => %{
                 "limit" => 1000,
                 "__typename" => "LimitReached"
               }
             }
           } = body
  end

  test "returns reader unavailable result", %{conn: conn} do
    mutation = """
    mutation CreatePaymentRequest($accountUid: ID!, $amount: Int!, $readerUid: ID) {
      createPaymentRequest(
        accountUid: $accountUid
        amount: $amount
        readerUid: $readerUid
      ) {
        ... on PaymentRequest {
          uid
          amount
          accountUid
          paymentMethods
        }
        ... on LimitReached {
          limit
        }
        ... on UnavailableReader {
          readerStatus
        }
        __typename
      }
    }
    """

    variables = %{
      "accountUid" => "35db6b7e-9493-4474-916f-37c04a137a86",
      "amount" => 123_000,
      "readerUid" => "unavailable"
    }

    body =
      conn
      |> post("/graphql", %{query: mutation, variables: variables})
      |> json_response(200)

    assert %{
             "data" => %{
               "createPaymentRequest" => %{
                 "readerStatus" => "requires_update",
                 "__typename" => "UnavailableReader"
               }
             }
           } = body
  end
end
