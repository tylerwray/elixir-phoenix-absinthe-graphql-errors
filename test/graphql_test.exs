defmodule MyAppWeb.GraphQLTest do
  use MyAppWeb.ConnCase, async: true

  test "returns an invoice", %{conn: conn} do
    mutation = """
    mutation CreateInvoice($accountUid: ID!, $amount: Int!) {
      createInvoice(accountUid: $accountUid, amount: $amount) {
        ... on Invoice {
          uid
          amount
          accountUid
          allowedPaymentMethods
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
               "createInvoice" => %{
                 "uid" => "7a53a356-f426-48ba-9d17-3cd3add62c30",
                 "amount" => 123_000,
                 "accountUid" => "35db6b7e-9493-4474-916f-37c04a137a86",
                 "allowedPaymentMethods" => ["CARD", "BANK_TRANSFER"],
                 "__typename" => "Invoice"
               }
             }
           } = body
  end

  test "returns limit reached result", %{conn: conn} do
    mutation = """
    mutation CreateInvoice($accountUid: ID!, $amount: Int!) {
      createInvoice(accountUid: $accountUid, amount: $amount) {
        ... on Invoice {
          uid
          amount
          accountUid
          allowedPaymentMethods
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
               "createInvoice" => %{
                 "limit" => 1000,
                 "__typename" => "LimitReached"
               }
             }
           } = body
  end

  test "returns reader unavailable result", %{conn: conn} do
    mutation = """
    mutation CreateInvoice($accountUid: ID!, $amount: Int!, $readerUid: ID) {
      createInvoice(
        accountUid: $accountUid
        amount: $amount
        readerUid: $readerUid
      ) {
        ... on Invoice {
          uid
          amount
          accountUid
          allowedPaymentMethods
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
               "createInvoice" => %{
                 "readerStatus" => "requires_update",
                 "__typename" => "UnavailableReader"
               }
             }
           } = body
  end
end
