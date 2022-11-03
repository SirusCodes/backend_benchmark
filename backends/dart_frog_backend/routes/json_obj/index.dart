import 'dart:convert';
import 'dart:io';

import 'package:compute/compute.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = await compute(_asyncDecode, body);
    return Response(body: data.length.toString());
  }
  return Response(statusCode: HttpStatus.notFound);
}

List<dynamic> _asyncDecode(String obj) {
  return jsonDecode(obj) as List;
}
