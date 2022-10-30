import 'package:benchmark/benchmark.dart' as benchmark;

typedef Stats = Future<double> Function();

Future<double> runMultiple(Stats func) async {
  final stats = await Future.wait(List.generate(10, (_) {
    Future.delayed(const Duration(seconds: 2));
    return func();
  }));
  return stats.reduce((v, e) => v + e) / stats.length;
}

Future<void> main(List<String> arguments) async {
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
}
