import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' show MediaType;

const host = "127.0.0.1:8080";

Future<double> getRTTTimePost(int requestCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(
    requestCount,
    () async {
      for (var i = 0; i < requestCount; i++) {
        await client.post(uri, body: body);
      }
    },
    () => client.close(),
  );
}

Future<double> getRTTTimeGet(int requestCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(
    requestCount,
    () async {
      for (var i = 0; i < requestCount; i++) {
        await client.get(uri);
      }
    },
    () => client.close(),
  );
}

Future<double> getRTTTimePostParallel(int requestCount) async {
  final body = jsonEncode({"name": "Darshan"});
  final uri = Uri.http(host, "/echo");
  final client = Client();
  return getTimeFor(
    requestCount,
    () async {
      await Future.wait(List.generate(
        requestCount,
        (_) => client.post(uri, body: body),
      ));
    },
    () => client.close(),
  );
}

Future<double> getRTTTimeGetParallel(int requestCount) async {
  final uri = Uri.http(host);
  final client = Client();
  return getTimeFor(
    requestCount,
    () async {
      await Future.wait(List.generate(
        requestCount,
        (_) => client.get(uri),
      ));
    },
    () => client.close(),
  );
}

Future<double> sendFile(int requestCount) async {
  final uri = Uri.http(host, "/file_upload");
  final bytes = await File("files/test.json").readAsBytes();

  return getTimeFor(requestCount, () async {
    for (var i = 0; i < requestCount; i++) {
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
    }
  });
}

Future<double> jsonParse(int requestCount) async {
  final uri = Uri.http(host, "/json_obj");
  final data = jsonEncode(await File("files/test.json").readAsString());
  final client = Client();
  return getTimeFor(
    requestCount,
    () async {
      for (var i = 0; i < requestCount; i++) {
        await client.post(
          uri,
          body: data,
          headers: {"content-type": "application/json"},
        );
      }
    },
    () => client.close(),
  );
}

Future<double> getTimeFor(
  int requestCount,
  Function func, [
  Function? dispose,
]) async {
  final stopwatch = Stopwatch()..start();
  await func();
  stopwatch.stop();
  dispose?.call();
  return stopwatch.elapsedMilliseconds / requestCount;
}
