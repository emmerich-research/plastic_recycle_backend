import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db.dart';

class Images {
  Router get router {
    final router = Router();
    router.get('/getAllDirectory', (Request request) async {
      List<dynamic> labels = [];
      await DataFetcher().getAllDirectory().then((value) {
        for (var element in value) {
          labels.add({"id": element[3], "label_id": element[0], "image_dir": element[1], "coordinate_dir": element[2]});
        }
      });

      return Response.ok(
        headers: {'Content-type': 'application/json'},
        json.encode({'code': 200, 'data': labels}),
      );
    });

    return router;
  }
}
