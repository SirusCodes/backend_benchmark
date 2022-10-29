import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.get) {
    return Response(body: 'Hello, World!');
  }
  return Response(statusCode: HttpStatus.notFound);
}
