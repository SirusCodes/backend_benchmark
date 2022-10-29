import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.json();
    return Response.json(body: {'response': "Hello, ${body["name"]}!"});
  }
  return Response(statusCode: HttpStatus.notFound);
}
