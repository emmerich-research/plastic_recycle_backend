import 'dart:async';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../database/db.dart';

class UploadAPI {
  Router get router {
    final router = Router();

    router.post('/picture/<label>/<width>/<height>/<centerX>/<centerY>',
        (Request request, String label, String width, String height, String centerX, String centerY) async {
      final contentType = request.headers['content-type'];

      if (contentType == null) {
        return Response(400, body: 'Content-type not found');
      }

      final mediaType = MediaType.parse(contentType);
      if (mediaType.mimeType != 'multipart/form-data') {
        return Response(400, body: 'invalid content-type');
      }

      final boundary = mediaType.parameters['boundary'];
      if (boundary == null) {
        return Response(400, body: 'Boundary not found');
      }

      final payload = request.read().asBroadcastStream();

      final parts = MimeMultipartTransformer(boundary).bind(payload).where((part) {
        return part.headers['content-type'] == 'image/png';
      });

      // Check Database for latest id of respective label
      dynamic id = await DataFetcher().getLatestId(int.parse(label));
      id ??= 0;

      await DataFetcher().insertNewImage(int.parse(label), '/home/it/Pictures/plastic_recycle/image/$label/${id + 1}.png',
          '/home/it/Pictures/plastic_recycle/text/$label/${id + 1}.txt', id + 1);

      final File file = File('/home/it/Pictures/plastic_recycle/text/$label/${id + 1}.txt');
      await file.writeAsString("$label,$width,$height,$centerX,$centerY");

      final partsIterator = StreamIterator(parts);
      while (await partsIterator.moveNext()) {
        final part = partsIterator.current;

        final file = File('/home/it/Pictures/plastic_recycle/image/$label/${id + 1}.png'); // direktori file upload
        if (await file.exists()) {
          await file.delete();
        }

        final chunksIterator = StreamIterator(part);
        while (await chunksIterator.moveNext()) {
          final chunk = chunksIterator.current;
          await file.writeAsBytes(chunk, mode: FileMode.append);
        }

        return Response.ok('Upload complete.');
      }

      return Response.ok(payload);
    });

    return router;
  }
}
