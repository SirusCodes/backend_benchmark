import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

// Doesn't support it https://github.com/VeryGoodOpenSource/dart_frog/issues/296
Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.post) {
    return Response();
  }
  return Response(statusCode: HttpStatus.notFound);
}
