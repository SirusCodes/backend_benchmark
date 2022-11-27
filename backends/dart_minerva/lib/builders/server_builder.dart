import 'package:minerva/minerva.dart';

class ServerBuilder extends MinervaServerBuilder {
  @override
  void build(ServerContext context) {
    // Inject dependency or resource
    context.store['message'] = 'Hello, world!';
  }
}
