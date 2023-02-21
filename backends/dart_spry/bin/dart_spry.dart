import 'package:spry/spry.dart';
import 'package:spry_json/spry_json.dart';
import 'package:spry_router/spry_router.dart';

void main(List<String> arguments) {
  final spry = Spry();
  final router = Router();

  router.get("/", (context) {
    context.response.json({"message": "Hello World!"});
  });

  router.post("/echo", (context) async {
    final name = (await context.request.json)["name"];
    context.response.json({"message": "Hello $name!"});
  });

  router.post("/file_upload", (context) {
    context.response.text("");
  });

  router.post("/json_obj", (context) async {
    final json = (await context.request.json);
    context.response.text(json.length.toString());
  });

  spry.listen(router, port: 8080);

  print("Server running at http://localhost:8080");
}
