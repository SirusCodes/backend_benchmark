// ignore_for_file: depend_on_referenced_packages

import 'package:spry/spry.dart';
import 'package:webfetch/webfetch.dart';

void main(List<String> arguments) async {
  final app = await Application.create(port: 8080);
  app.get("/", (request) {
    return {"message": "Hello World!"};
  });

  app.post("/echo", (request) async {
    final body = (await request.json());
    if (body is Map) {
      return {"message": "Hello ${body["name"]}!"};
    }

    throw Abort(404);
  });

  app.post("/file_upload", (request) async {
    final formData = await request.formData();
    final benchmark = formData.get("benchmark");

    return (benchmark as Blob).size;
  });

  app.post("/json_obj", (request) async {
    final json = await request.json();

    return (json as Iterable).length;
  });

  app.listen();

  print("Server running at http://localhost:8080");
}
