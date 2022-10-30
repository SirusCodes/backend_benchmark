import 'dart:convert';

import 'package:http/http.dart';

const host = "127.0.0.1:8080";

Future<double> getRTTTimePost(int requestCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(requestCount, () async {
    for (var i = 0; i < requestCount; i++) {
      await client.post(uri, body: body);
    }
    client.close();
  });
}

Future<double> getRTTTimeGet(int requestCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(requestCount, () async {
    for (var i = 0; i < requestCount; i++) {
      await client.get(uri);
    }
    client.close();
  });
}

Future<double> getRTTTimePostParallel(int requestCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(requestCount, () async {
    await Future.wait(List.generate(
      requestCount,
      (_) => client.post(uri, body: body),
    ));
    client.close();
  });
}

Future<double> getRTTTimeGetParallel(int requestCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(requestCount, () async {
    await Future.wait(List.generate(
      requestCount,
      (_) => client.get(uri),
    ));
    client.close();
  });
}

Future<double> getTimeFor(int requestCount, Function func) async {
  final stopwatch = Stopwatch()..start();
  await func();
  stopwatch.stop();
  return stopwatch.elapsedMilliseconds / requestCount;
}
