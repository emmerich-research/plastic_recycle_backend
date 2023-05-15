import 'dart:async';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UploadAPI {
  Router get router {
    final router = Router();

    router.post('/picture', (Request request) async {
      final contentType = request.headers['content-type'];
      if (contentType == null) {
        return Response(400, body: 'content-type tidak ditemukan');
      }

      final mediaType = MediaType.parse(contentType);
      if (mediaType.mimeType != 'multipart/form-data') {
        return Response(400, body: 'content-type tidak valid');
      }

      final boundary = mediaType.parameters['boundary'];
      if (boundary == null) {
        return Response(400, body: 'boundary tidak ditemukan');
      }

      final payload = request.read();
      final parts = MimeMultipartTransformer(boundary).bind(payload).where((part) {
        return part.headers['content-type'] == 'image/png';
      });

      final partsIterator = StreamIterator(parts);

      while (await partsIterator.moveNext()) {
        final part = partsIterator.current;

        final file = File('./uploads/testing.png'); // direktori file upload
        if (await file.exists()) {
          await file.delete();
        }
        final chunksIterator = StreamIterator(part);
        while (await chunksIterator.moveNext()) {
          final chunk = chunksIterator.current;
          await file.writeAsBytes(chunk, mode: FileMode.append);
        }

        return Response.ok('Upload Berhasil');
      }

      return Response.ok(payload);
    });

    return router;
  }
}
