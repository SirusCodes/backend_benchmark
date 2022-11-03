import 'dart:io';

import 'package:benchmark/benchmark.dart' as benchmark;

typedef Stats = Future<double> Function();

Future<double> runMultiple(Stats func) async {
  final stats = await Future.wait(List.generate(10, (_) {
    Future.delayed(const Duration(seconds: 2));
    return func();
  }));
  return stats.reduce((v, e) => v + e) / stats.length;
}

Future<int> main(List<String> arguments) async {
  // Round trip time
  print("\nRequests in sync");
  final rttGet = await runMultiple(() => benchmark.getRTTTimeGet(1000));
  print("GET RTT: ${rttGet}ms");
  final rttPost = await runMultiple(() => benchmark.getRTTTimePost(1000));
  print("POST RTT: ${rttPost}ms");

  // Round trip time in Parallel
  print("\nRequests in parallel");
  final rttGetParallel = await runMultiple(
    () => benchmark.getRTTTimeGetParallel(50),
  );
  print("GET RTT: ${rttGetParallel}ms");
  final rttPostParallel = await runMultiple(
    () => benchmark.getRTTTimePostParallel(50),
  );
  print("POST RTT: ${rttPostParallel}ms");

  // Sending files to server
  final fileSize = File("files/test.json").lengthSync() / 1024;
  print("\nSending files");
  final sendFileTime = await runMultiple(() => benchmark.sendFile(100));
  print("Send file (${fileSize.toStringAsFixed(2)}KB): ${sendFileTime}ms");

  // Json parsing speed
  print("\nChecking json parsing speed");
  final parseJsonTime = await runMultiple(() => benchmark.jsonParse(100));
  print("Parse JSON: ${parseJsonTime}ms");

  return 0;
}
