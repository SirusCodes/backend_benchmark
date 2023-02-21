import 'dart:convert';
import 'dart:io';

import 'package:benchmark/benchmark.dart' as benchmark;

const interation = 20;
const syncReqCount = 1000;
const asyncBurstReqCount = 250;
const fileReqCount = 100;
const jsonReqCount = 100;

Future<int> main(List<String> arguments) async {
  final name = arguments.length == 1 ? arguments[0] : "none";

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
    rttGet.add(await benchmark.getRTTTimeGet(syncReqCount));
    rttPost.add(await benchmark.getRTTTimePost(syncReqCount));

    // Round trip time in Parallel
    rttGetParallel
        .add(await benchmark.getRTTTimeGetParallel(1, asyncBurstReqCount));
    rttPostParallel
        .add(await benchmark.getRTTTimePostParallel(1, asyncBurstReqCount));

    // Sending files to server
    sendFileTime.add(await benchmark.sendFile(fileReqCount));

    // Json parsing speed
    parseJsonTime.add(await benchmark.jsonParse(jsonReqCount));

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

  saveResults(
    {
      "get_rtt": rttGet.average(),
      "post_rtt": rttPost.average(),
      "get_rtt_parallel": rttGetParallel.average(),
      "post_rtt_parallel": rttPostParallel.average(),
      "send_file": sendFileTime.average(),
      "parse_json": parseJsonTime.average(),
      "file_size": fileSize,
    },
    name,
  );

  return 0;
}

void saveResults(Map<String, num> result, String name) {
  final file = File("./results/$name.json");
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.createSync(recursive: true);
  file.writeAsStringSync(jsonEncode(result));
}
