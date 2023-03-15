import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final formData = await context.request.formData();
    final data = await formData.files['benchmark']!.readAsBytes();
    return Response(body: data.length.toString());
  }
  return Response(statusCode: HttpStatus.notFound);
}
