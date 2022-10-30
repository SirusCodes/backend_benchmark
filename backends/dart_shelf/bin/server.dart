import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..post('/echo', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!');
}

Future<Response> _echoHandler(Request request) async {
  final string = await request.readAsString();
  final body = json.decode(string);
  return Response.ok(json.encode({"response": "Hello, ${body["name"]}!"}));
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress("127.0.0.1");

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.address.host}:${server.port}');
}
