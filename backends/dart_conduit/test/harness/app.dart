import 'package:dart_conduit/dart_conduit.dart';
import 'package:conduit_test/conduit_test.dart';

export 'package:dart_conduit/dart_conduit.dart';
export 'package:conduit_test/conduit_test.dart';
export 'package:test/test.dart';
export 'package:conduit/conduit.dart';

/// A testing harness for dart_conduit.
///
/// A harness for testing an conduit application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<DartConduitChannel> {
  @override
  Future onSetUp() async {}

  @override
  Future onTearDown() async {}
}
