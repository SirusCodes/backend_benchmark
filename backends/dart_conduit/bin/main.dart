import 'package:dart_conduit/dart_conduit.dart';

Future main() async {
  final app = Application<DartConduitChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8080;

  await app.startOnCurrentIsolate();

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
