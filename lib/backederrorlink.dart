library backederrorlink;

import 'dart:async';

import 'package:http/http.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql/internal.dart';

typedef Callback = Function(FetchResult, StreamedResponse);

class BackendErrorLink extends Link {
  BackendErrorLink({
    this.onClientError,
    this.onUnauthorized,
    this.onForbidden,
    this.onNotFound,
    this.onServerError,
    this.onUnknownError,
  }) : super(
          request: (Operation operation, [NextLink forward]) {
            StreamController<FetchResult> controller;

            Future<void> onListen() async {
              await controller
                  .addStream(forward(operation).map((FetchResult result) {
                if (result != null && result.errors != null) {
                  StreamedResponse response =
                      operation.getContext()["response"];
                  if (response != null) {
                    switch (response.statusCode) {
                      case 400:
                        onClientError(result, response);
                        break;
                      case 401:
                        onUnauthorized(result, response);
                        break;
                      case 403:
                        onForbidden(result, response);
                        break;
                      case 404:
                        onNotFound(result, response);
                        break;
                      case 500:
                      case 501:
                      case 502:
                      case 503:
                        onServerError(result, response);
                        break;
                      default:
                        onUnknownError(result, response);
                        break;
                    }
                  }
                }

                return result;
              }));

              await controller.close();
            }

            controller = StreamController<FetchResult>(onListen: onListen);

            return controller.stream;
          },
        );

  Callback onClientError;
  Callback onUnauthorized;
  Callback onForbidden;
  Callback onNotFound;
  Callback onServerError;
  Callback onUnknownError;
}
