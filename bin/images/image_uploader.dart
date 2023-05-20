import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../database/db.dart';

class UploadAPI {
  Router get router {
    final router = Router();

    router.post('/picture/<label>/<width>/<height>/<centerX>/<centerY>',
        (Request request, String label, String width, String height, String centerX, String centerY) async {
      try {
        // Check Database for latest id of respective label
        dynamic id = await DataFetcher().getLatestId(int.parse(label));
        id ??= 0;

        final content = await request.readAsString();
        var queryParams = Uri(query: content).queryParameters;

        // IMAGE FILE
        File image = await File('/home/it/Pictures/plastic_recycle/image/$label/${id + 1}.png').create();
        image.writeAsBytesSync(base64Decode(queryParams['media']!));

        // ADD TO DATABASE
        await DataFetcher().insertNewImage(int.parse(label), '/home/it/Pictures/plastic_recycle/image/$label/${id + 1}.png',
            '/home/it/Pictures/plastic_recycle/text/$label/${id + 1}.txt', id + 1);

        // TEXT FILE
        final File file = File('/home/it/Pictures/plastic_recycle/text/$label/${id + 1}.txt');
        await file.writeAsString("$label,$width,$height,$centerX,$centerY");

        return Response.ok(
          json.encode(queryParams),
          headers: {'Content-type': 'application/json'},
        );
      } catch (e) {
        print(e);
      }
    });

    return router;
  }
}
