# backederrorlink

BackendErrorLink for graphql_flutter

## Getting Started

```
final BackendErrorLink backendErrorLink = BackendErrorLink(
    onUnauthorized: (FetchResult result, StreamedResponse response) {
    expect(new Future.value(response.statusCode), completion(equals(401)));
});

final HttpLink httpLink = HttpLink(
    uri:
        'https://requestloggerbin.herokuapp.com/bin/2c0b451d-b679-4d5b-8687-0d891bead416/view');

final Link link = backendErrorLink.concat(httpLink as Link);

GraphQLClient graphQLClient = GraphQLClient(
    cache: OptimisticCache(
    dataIdFromObject: typenameDataIdFromObject,
    ),
    link: link,
);

await graphQLClient.query(QueryOptions(
    document: '''
    {
        user {
        user
        }
    }
    ''',
));
```