import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'upload/upload.dart';
import 'user/user.dart';

// Configure routes.

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress("192.168.5.51");
  // final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final router = Router();
  router.mount('/user', UserApi().router);
  router.mount('/upload', UploadAPI().router);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${ip.host}:${server.port}');
}
