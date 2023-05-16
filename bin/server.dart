import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'images/get.dart';
import 'labels/label.dart';
import 'images/upload.dart';
import 'user/user.dart';

// Configure routes.

void main(List<String> args) async {
  final ip = InternetAddress("192.168.5.51");

  // Configure a pipeline that logs requests.
  final router = Router();
  router.mount('/user', UserApi().router);
  router.mount('/upload', UploadAPI().router);
  router.mount('/labels', Labels().router);
  router.mount('/images', Images().router);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '14450');
  final server = await serve(handler, ip, port);
  print('Server listening on ${ip.host}:${server.port}');
}
