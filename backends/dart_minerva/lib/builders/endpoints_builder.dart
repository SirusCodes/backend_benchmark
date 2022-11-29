import 'dart:convert';

import 'package:minerva/minerva.dart';

class EndpointsBuilder extends MinervaEndpointsBuilder {
  @override
  void build(Endpoints endpoints) {
    endpoints.get('/', _root);

    endpoints.post('/echo', _echo);

    endpoints.post('/file_upload', _fileUpload);

    endpoints.post('/json_obj', _jsonObject);
  }

  dynamic _root(ServerContext context, MinervaRequest request) {
    return {'response': 'Hello, world!'};
  }

  dynamic _echo(ServerContext context, MinervaRequest request) async {
    var json = await request.body.asJson();

    return {"response": "Hello, ${json['name']}!"};
  }

  dynamic _fileUpload(ServerContext context, MinervaRequest request) async {
    var form = await request.body.asForm();

    var field = form.data['benchmark'] as FormDataFile;

    return utf8.decode(field.bytes).length;
  }

  dynamic _jsonObject(ServerContext context, MinervaRequest request) async {
    var json = await request.body.asJson();

    return json.length;
  }
}
