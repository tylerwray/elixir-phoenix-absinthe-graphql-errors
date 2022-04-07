# GraphQL error separation best practices

This is an example repository showing how to implement a better separation of Errors in GraphQL so that
not all non-expected results are "Errors". See https://www.youtube.com/watch?v=RDNTP66oY2o

You can spin up the phoenix app with `mix phx.server` and launch graphiql at `localhost:4000/graphiql`.

You can then run a series of request with the following mutation to see different outcomes:

```graphql
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
```

## PaymentRequest

Send anything as `accountUid` and an integer `amount` to see the `PaymentRequest` response:

```json
{
  "accountUid": "e7769c87-a11d-4b9d-be24-091c41af2ff3",
  "amount": 1200
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
