# GraphQL error separation best practices

This is an example repository showing how to implement a better separation of Errors in GraphQL so that
not all non-expected results are "Errors". See https://www.youtube.com/watch?v=RDNTP66oY2o

You can spin up the phoenix app with `mix phx.server` and launch graphiql at `localhost:4000/graphiql`.

You can then run a series of requests with the following mutation to see different outcomes:

```graphql
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
```

## Invoice

Send anything as `accountUid` and an integer `amount` to see the `Invoice` response:

```json
{
  "uid": "e7769c87-a11d-4b9d-be24-091c41af2ff3",
  "accountUid": "e7769c87-a11d-4b9d-be24-091c41af2ff3",
  "amount": 1200,
  "allowedPaymentMethods": ["CARD"]
}
```

## LimitReached

Send `accountUid` as `limit_reached` to see the `LimitReached` response:

```json
{
  "accountUid": "limit_reached",
  "amount": 1200
}
```

## UnavailableReader

Send `readerUid` as `unavailable` to see the `UnavailableReader` response:

```json
{
  "accountUid": "901aa71e-2c67-49f0-a057-b31962bfb146",
  "amount": 1200,
  "readerUid": "unavailable"
}
```
