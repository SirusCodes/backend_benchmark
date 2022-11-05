import 'dart:io';

import 'package:benchmark/benchmark.dart' as benchmark;

const interation = 20;

Future<int> main(List<String> arguments) async {
  final List<double> rttGet = [],
      rttPost = [],
      rttGetParallel = [],
      rttPostParallel = [],
      sendFileTime = [],
      parseJsonTime = [];

  final fileSize = File("files/test.json").lengthSync() / 1024;

  for (var i = 0; i < interation; i++) {
    print("Running ${i + 1} iteration...");

    // Round trip time
    rttGet.add(await benchmark.getRTTTimeGet(1000));
    rttPost.add(await benchmark.getRTTTimePost(1000));

    // Round trip time in Parallel
    rttGetParallel.add(await benchmark.getRTTTimeGetParallel(1, 500));
    rttPostParallel.add(await benchmark.getRTTTimePostParallel(1, 500));

    // Sending files to server
    sendFileTime.add(await benchmark.sendFile(100));

    // Json parsing speed
    parseJsonTime.add(await benchmark.jsonParse(100));

    await Future.delayed(const Duration(seconds: 2));
  }

  print("\nRequests in sync");
  print("GET RTT: ${rttGet.average()}ms");
  print("POST RTT: ${rttPost.average()}ms");

  print("\nRequests in parallel");
  print("GET RTT: ${rttGetParallel.average()}ms");
  print("POST RTT: ${rttPostParallel.average()}ms");

  print("\nFile upload");
  print(
    "Send file (${fileSize.toStringAsFixed(2)}KB): ${sendFileTime.average()}ms",
  );

  print("\nJSON parsing speed");
  print("Parse JSON: ${parseJsonTime.average()}ms");

  return 0;
}
