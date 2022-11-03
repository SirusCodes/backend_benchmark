import 'package:dart_conduit/dart_conduit.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class DartConduitChannel extends ApplicationChannel {
  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/").linkFunction((request) async {
      if (request.method == "GET") {
        return Response.ok("Hello, World!");
      }
      return Response.notFound();
    });

    router.route("/echo").linkFunction((request) async {
      if (request.method == "POST") {
        final body = await request.body.decode<Map<String, dynamic>>();
        return Response.ok({"response": "Hello, ${body["name"]}!"});
      }
      return Response.notFound();
    });

    router.route("/json_obj").linkFunction((request) async {
      if (request.method == "POST") {
        final body = await request.body.decode<Map<String, dynamic>>();
        return Response.ok(body.length.toString());
      }
      return Response.notFound();
    });

    return router;
  }
}
