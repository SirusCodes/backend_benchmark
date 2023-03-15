import 'dart:convert';
import 'dart:io';

import 'package:dia/dia.dart';
import 'package:dia_body/dia_body.dart';
import 'package:dia_router/dia_router.dart';

class ServerContext extends Context with Routing, ParsedBody {
  ServerContext(super.request);

  @override
  String toString() {
    var res = <String, String>{};
    res['query'] = query.toString();
    res['params'] = params.toString();
    res['files'] = files.toString();
    res['parsed'] = parsed.toString();

    return res.toString();
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = "127.0.0.1";

  final app = App<ServerContext>((req) => ServerContext(req));

  final router = Router<ServerContext>('/');

  router.get('/', (ctx, next) async {
    ctx.body = json.encode({"response": 'Hello, World!'});
  });
  router.post('/echo', (ctx, next) async {
    final map = ctx.parsed;
    ctx.body = json.encode({"response": "Hello, ${map["name"]}!"});
  });
  router.post('/file_upload', (ctx, next) async {
    final file = ctx.files['benchmark'];
    ctx.body = file?.first.file.lengthSync().toString() ?? '0';
  });
  router.post('/json_obj', (ctx, next) async {
    final body = ctx.parsed;
    ctx.body = body.length.toString();
  });

  app.use(body());
  app.use(router.middleware);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  app
      .listen(ip, port)
      .then((info) => print('Server listening on port $ip:$port'));
}
