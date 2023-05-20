import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import 'images/get.dart';
import 'images/image_uploader.dart';
import 'labels/label.dart';
import 'user/user.dart';

// Configure routes.

void main(List<String> args) async {
  final ip = InternetAddress("192.168.5.51");

  // Configure a pipeline that logs requests.
  final router = Router();
  router.mount('/user', UserApi().router);
  router.mount('/api/upload', UploadAPI().router);
  router.mount('/labels', Labels().router);
  router.mount('/images', Images().router);

  final handler = Pipeline().addMiddleware(corsHeaders()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '14450');
  final server = await serve(handler, ip, port);
  print('Server listening on ${ip.host}:${server.port}');
}
