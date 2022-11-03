import 'dart:convert';
import 'dart:io';

import 'package:compute/compute.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..post('/echo', _echoHandler)
  ..post("/file_upload", _fileUpload)
  ..post("/json_obj", _jsonObj);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!');
}

Future<Response> _echoHandler(Request request) async {
  final string = await request.readAsString();
  final body = json.decode(string);
  return Response.ok(json.encode({"response": "Hello, ${body["name"]}!"}));
}

Future<Response> _fileUpload(Request request) async {
  final parameters = <String, String>{
    await for (final formData in request.multipartFormData)
      formData.name: await formData.part.readString(),
  };

  return Response.ok(parameters["benchmark"]?.length.toString());
}

Future<Response> _jsonObj(Request request) async {
  final body = await request.readAsString();
  final data = await compute(_asyncDecode, body);
  return Response.ok(data.length.toString());
}

_asyncDecode(String obj) {
  return jsonDecode(obj);
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
