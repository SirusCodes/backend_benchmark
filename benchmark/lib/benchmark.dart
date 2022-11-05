import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' show MediaType;

const host = "127.0.0.1:8080";

extension ListAvg<T extends num> on List<T> {
  double average() {
    num sum = (T == int ? 0 : 0.0) as T;
    for (num current in this) {
      sum += current;
    }
    return sum / length;
  }
}

Future<double> getRTTTimePost(int requestCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(
    requestCount,
    () => client.post(uri, body: body),
    () => client.close(),
  );
}

Future<double> getRTTTimeGet(int requestCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(
    requestCount,
    () => client.get(uri),
    () => client.close(),
  );
}

Future<double> getRTTTimePostParallel(int requestCount, int burstCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(
    requestCount,
    () => Future.wait(List.generate(
      burstCount,
      (_) => client.post(uri, body: body),
    )),
    () => client.close(),
  );
}

Future<double> getRTTTimeGetParallel(int requestCount, int burstCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(
    requestCount,
    () => Future.wait(List.generate(
      requestCount,
      (_) => client.get(uri),
    )),
    () => client.close(),
  );
}

Future<double> sendFile(int requestCount) async {
  final uri = Uri.http(host, "/file_upload");
  final bytes = await File("files/test.json").readAsBytes();

  return getTimeFor(requestCount, () async {
    final request = MultipartRequest("POST", uri)
      ..files.add(MultipartFile.fromBytes(
        "benchmark",
        bytes,
        filename: "test.json",
        contentType: MediaType("application", "json"),
      ));
    final res = await Response.fromStream(await request.send());
    if (res.statusCode != 200) {
      throw Exception("Failed");
    }
  });
}

Future<double> jsonParse(int requestCount) async {
  final uri = Uri.http(host, "/json_obj");
  final data = await File("files/test.json").readAsString();
  final client = Client();
  return getTimeFor(
    requestCount,
    () => client.post(
      uri,
      body: data,
      headers: {"content-type": "application/json"},
    ),
    () => client.close(),
  );
}

Future<double> getTimeFor(
  int requestCount,
  Function func, [
  Function? dispose,
]) async {
  final interation = <int>[];
  final stopwatch = Stopwatch();
  for (var i = 0; i < requestCount; i++) {
    stopwatch.start();
    await func();
    stopwatch.stop();
    interation.add(stopwatch.elapsedMicroseconds);
    stopwatch.reset();
  }
  dispose?.call();

  return interation.average();
}
